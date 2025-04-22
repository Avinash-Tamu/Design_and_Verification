#include <iostream>
#include <vector>
#include <unordered_map>
#include <unordered_set>
#include <cmath>
#include <limits>
#include <fstream>
#include <sstream>
#include <string>

// MOESI states
enum MOESIState { M, O, E, S, I };

struct CacheLine {
    uint64_t tag;
    MOESIState state;
};

struct DirectoryEntry {
    MOESIState state = I;
    std::unordered_set<int> sharers;
    int owner = -1;
};

class Cache {
public:
    std::unordered_map<uint64_t, CacheLine> lines;
    size_t max_size = 64;

    bool hasLine(uint64_t tag) const {
        return lines.find(tag) != lines.end();
    }

    MOESIState getState(uint64_t tag) const {
        return lines.at(tag).state;
    }

    void setLine(uint64_t tag, MOESIState state) {
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

    Core(int id_) : id(id_) {}
};

class MOESISimulator {
public:
    std::vector<Core> cores;
    std::unordered_map<uint64_t, DirectoryEntry> directory;
    int memoryAccesses = 0;
    
    int latency = 0;
    int totalReads = 0;
    int cacheHits = 0;
    int effectiveHits = 0;

    int cacheToCacheTransfers = 0;
    int invalidations = 0;

    MOESISimulator(int dimX, int dimY) {
        int id = 0;
        for (int i = 0; i < dimY; ++i) {
            for (int j = 0; j < dimX; ++j) {
                cores.emplace_back(id++);
            }
        }
    }

    void readAccess(int coreId, uint64_t address) {
        uint64_t tag = address >> 6;
        auto& core = cores[coreId];
        totalReads++;

        if (core.l2.hasLine(tag)) {
            cacheHits++;
            effectiveHits++;
            return;
        }

        auto& entry = directory[tag];

        if (entry.state == M || entry.state == O) {
            auto& owner = cores[entry.owner];
            owner.l2.setLine(tag, O);
            core.l2.setLine(tag, S);
            entry.sharers.insert(coreId);
            entry.state = S;
            cacheToCacheTransfers++;
            latency += 30;
            effectiveHits++;
            return;
        }

        for (int sid : entry.sharers) {
            if (sid != coreId && cores[sid].l2.hasLine(tag)) {
                core.l2.setLine(tag, S);
                entry.sharers.insert(coreId);
                cacheToCacheTransfers++;
	        latency += 30;
                effectiveHits++;

                return;
            }
        }

        memoryAccesses++;
        latency += 100;
        core.l2.setLine(tag, E);
        entry.sharers.insert(coreId);
        entry.state = E;
    }

    void writeAccess(int coreId, uint64_t address) {
        uint64_t tag = address >> 6;
        auto& core = cores[coreId];
        auto& entry = directory[tag];
// Count memory access if the line is not present in cache
    if (!core.l2.hasLine(tag)) {
        memoryAccesses++;
        latency += 100;
    }

        for (int sid : entry.sharers) {
            if (sid != coreId) {
                cores[sid].l2.invalidate(tag);
                invalidations++;
            }
        }

        entry.sharers.clear();
        core.l2.setLine(tag, M);
        entry.owner = coreId;
        entry.sharers = {coreId};
        entry.state = M;
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

            if (op == "READ") readAccess(core, addr);
            else if (op == "WRITE") writeAccess(core, addr);
        }
    }

void printStats() const {
    std::cout << "Memory accesses: " << memoryAccesses << "\n";
    std::cout << "Cache-to-cache transfers: " << cacheToCacheTransfers << "\n";
    std::cout << "Invalidations: " << invalidations << "\n";
    std::cout << "Total simulated latency: " << latency << " cycles\n";
    std::cout << "Cache hits: " << cacheHits << "\n";
    std::cout << "Effective hits (includes remote caches): " << effectiveHits << "\n";
    std::cout << "Total reads: " << totalReads << "\n";
    std::cout << "Cache hit rate: " << (totalReads > 0 ? (100.0 * cacheHits / totalReads) : 0.0) << "%\n";
    std::cout << "Effective hit rate: " << (totalReads > 0 ? (100.0 * effectiveHits / totalReads) : 0.0) << "%\n";
    std::cout << "--- End of MOESI Stats ---" << std::endl;
}
}; 

int main(int argc, char* argv[]) {
    if (argc < 2) {
        std::cerr << "Usage: " << argv[0] << " <benchmark_file>\n";
        return 1;
    }

    MOESISimulator sim(4, 4);
    sim.runBenchmark(argv[1]);
    sim.printStats();
    return 0;
}

