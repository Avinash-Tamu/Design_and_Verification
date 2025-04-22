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

    int distanceTo(const Core& other) const {
        return std::abs(x - other.x) + std::abs(y - other.y);
    }
};

class BaselineSimulator {
public:
    std::vector<Core> cores;
    std::unordered_map<uint64_t, DirectoryEntry> directory;
    int cacheToCacheTransfers = 0;
    int memoryAccesses = 0;
    int invalidationMessages = 0;
    int latency = 0;
    int totalReads = 0;
    int cacheHits = 0;
    int effectiveHits = 0;

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
        totalReads++;

        if (requester.l2.hasLine(tag)) {
            cacheHits++;
            effectiveHits++;
            return;
        }

        auto& dirEntry = directory[tag];

        // Only allow cache-to-cache transfer from dirty owner (M state)
        if (dirEntry.state == M && dirEntry.owner != requesterId) {
            auto& owner = cores[dirEntry.owner];
            owner.l2.setLine(tag, S);
            requester.l2.setLine(tag, S);
            dirEntry.sharers.insert(requesterId);
            dirEntry.state = S;
            cacheToCacheTransfers++;
            latency += 30;
            effectiveHits++;
            return;
        }

        // Fetch from memory for clean data (baseline model)
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
        std::cout << "Cache hits: " << cacheHits << "\n";
        std::cout << "Effective hits (includes remote caches): " << effectiveHits << "\n";
        std::cout << "Total reads: " << totalReads << "\n";
        std::cout << "Cache hit rate: " << (totalReads > 0 ? (100.0 * cacheHits / totalReads) : 0.0) << "%\n";
        std::cout << "Effective hit rate: " << (totalReads > 0 ? (100.0 * effectiveHits / totalReads) : 0.0) << "%\n";
    }
};

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <benchmark_file>\n";
        return 1;
    }

    std::string filename = argv[1];
    BaselineSimulator sim(4, 4);
    sim.runBenchmark(filename);
    sim.printStats();
    return 0;
}

