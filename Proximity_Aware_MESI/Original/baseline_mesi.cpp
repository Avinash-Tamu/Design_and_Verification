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

    void setLine(uint64_t tag, MESIState state) {
        if (lines.size() >= max_size) {
            lines.erase(lines.begin());
        }
        lines[tag] = {tag, state};
    }

    void invalidate(uint64_t tag) {
        lines.erase(tag);
    }
};

class Core {
public:
    int id;
    Cache l2;
    int x, y;

    Core(int id_, int x_, int y_) : id(id_), x(x_), y(y_) {}
};

class BaselineSimulator {
public:
    std::vector<Core> cores;
    std::unordered_map<uint64_t, DirectoryEntry> directory;
    int cacheToCacheTransfers = 0;
    int memoryAccesses = 0;
    int invalidationMessages = 0;
    int latency = 0;

    BaselineSimulator(int dimX, int dimY) {
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

        // Simulate cache-to-cache transfer only if data is modified in another cache
        if (dirEntry.state == M && dirEntry.owner != requesterId) {
            auto& owner = cores[dirEntry.owner];
            owner.l2.setLine(tag, S);
            requester.l2.setLine(tag, S);
            dirEntry.sharers.insert(requesterId);
            dirEntry.state = S;
            cacheToCacheTransfers++;
            latency += 30; // cache-to-cache latency
            return;
        }

        // Otherwise fetch from memory
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

        for (int sid : dirEntry.sharers) {
            if (sid != requesterId) {
                cores[sid].l2.invalidate(tag);
                invalidationMessages++;
            }
        }

        dirEntry.sharers.clear();
        requester.l2.setLine(tag, M);
        dirEntry.state = M;
        dirEntry.owner = requesterId;
        dirEntry.sharers = {requesterId};
        latency += 100;
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
    BaselineSimulator sim(4, 4);
    sim.runBenchmark("benchmark1.txt");
    sim.printStats();
    return 0;
}

