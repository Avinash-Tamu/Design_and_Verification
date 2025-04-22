#include <iostream>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <set>
#include <cmath>
#include <limits>
#include <fstream>
#include <sstream>
#include <string>

enum MESIState { M, E, S, I };

struct CacheLine {
    uint64_t tag;
    MESIState state;
};

struct DirectoryEntry {
    MESIState state = I;
    std::unordered_set<int> sharers;
    int owner = -1;
};

class Cache {
public:
    std::unordered_map<uint64_t, CacheLine> lines;
    size_t max_size = 64;

    bool hasLine(uint64_t tag) {
        return lines.find(tag) != lines.end();
    }

    MESIState getState(uint64_t tag) {
        return lines[tag].state;
    }

    void setLine(uint64_t tag, MESIState state) {
        if (lines.size() >= max_size) {
            evictLine();
        }
        lines[tag] = {tag, state};
    }

    void invalidate(uint64_t tag) {
        lines.erase(tag);
    }

    bool evictLine() {
        if (!lines.empty()) {
            lines.erase(lines.begin());
            return true;
        }
        return false;
    }
};

class Core {
public:
    int id;
    Cache l2;
    int x, y;

    Core(int id_, int x_, int y_) : id(id_), x(x_), y(y_) {}

    int distanceTo(const Core& other) const {
        return std::abs(x - other.x) + std::abs(y - other.y);
    }
};

class Simulator {
public:
    std::vector<Core> cores;
    std::unordered_map<uint64_t, DirectoryEntry> directory;
    int cacheToCacheTransfers = 0;
    int memoryAccesses = 0;
    int invalidationMessages = 0;
    int latency = 0;
    const int hop_latency = 3;

    Simulator(int dimX, int dimY) {
        int id = 0;
        for (int i = 0; i < dimY; ++i) {
            for (int j = 0; j < dimX; ++j) {
                cores.emplace_back(id++, j, i);
            }
        }
    }

    void readAccess(int requesterId, uint64_t address) {
        uint64_t tag = address >> 6;
        auto& requester = cores[requesterId];

        if (requester.l2.hasLine(tag)) return;

        auto& dirEntry = directory[tag];

        if (dirEntry.state == M || dirEntry.state == E) {
            int owner = dirEntry.owner;
            latency += cores[owner].distanceTo(requester) * hop_latency;
            requester.l2.setLine(tag, S);
            cores[owner].l2.setLine(tag, S);
            dirEntry.sharers.insert(requesterId);
            dirEntry.state = S;
            cacheToCacheTransfers++;
            return;
        }

        if (!dirEntry.sharers.empty()) {
            int closestId = -1;
            int minDist = std::numeric_limits<int>::max();
            for (int sid : dirEntry.sharers) {
                int dist = requester.distanceTo(cores[sid]);
                if (dist < minDist) {
                    minDist = dist;
                    closestId = sid;
                }
            }

            if (closestId != -1 && cores[closestId].l2.hasLine(tag)) {
                requester.l2.setLine(tag, S);
                dirEntry.sharers.insert(requesterId);
                latency += minDist * hop_latency;
                cacheToCacheTransfers++;
                return;
            }
        }

        memoryAccesses++;
        requester.l2.setLine(tag, E);
        dirEntry.sharers.insert(requesterId);
        dirEntry.state = E;
        dirEntry.owner = requesterId;
        latency += 100;
    }

    void writeAccess(int requesterId, uint64_t address) {
        uint64_t tag = address >> 6;
        auto& requester = cores[requesterId];

        auto& dirEntry = directory[tag];

        if (dirEntry.state == M && dirEntry.owner == requesterId) return;

        if (dirEntry.state == S) {
            for (int sid : dirEntry.sharers) {
                if (sid != requesterId) {
                    cores[sid].l2.invalidate(tag);
                    invalidationMessages++;
                }
            }
            dirEntry.sharers.clear();
        }

        if ((dirEntry.state == M || dirEntry.state == E) && dirEntry.owner != requesterId) {
            auto& ownerCore = cores[dirEntry.owner];
            ownerCore.l2.invalidate(tag);
            invalidationMessages++;
        }

        requester.l2.setLine(tag, M);
        dirEntry.state = M;
        dirEntry.owner = requesterId;
        dirEntry.sharers = {requesterId};
        latency += 50;
    }

    void runBenchmark(const std::string& filename) {
        std::ifstream file(filename);
        std::string line;

        while (std::getline(file, line)) {
            std::istringstream iss(line);
            std::string op;
            int core;
            uint64_t addr;

            if (!(iss >> op >> core >> std::hex >> addr)) continue;

            if (op == "READ")
                readAccess(core, addr);
            else if (op == "WRITE")
                writeAccess(core, addr);
        }
    }

    void printStats() const {
        std::cout << "Cache-to-cache transfers: " << cacheToCacheTransfers << "\n";
        std::cout << "Memory accesses: " << memoryAccesses << "\n";
        std::cout << "Invalidation messages: " << invalidationMessages << "\n";
        std::cout << "Total simulated latency: " << latency << " cycles\n";
    }
};

int main() {
    Simulator sim(4, 4); // 4x4 mesh, 16 cores
    sim.runBenchmark("benchmark1.txt");
    sim.printStats();
    return 0;
}

