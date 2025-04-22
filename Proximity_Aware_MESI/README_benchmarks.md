##Base protocols directory -> Original
##Modified running code -> Modified
##Benchmarks directory -> benchmarks
##List ofbenchmarks and their applications given below

##Executable for simulation :
##MESI -> base_mesi_sim
##MOESI -> moesi_sim
##Proximity aware MESI -> proximity_mesi_sim

##After any change in code first we need to run 
##1 g++ -std=c++11 -o proximity_mesi_sim ./Modified/proximity_mesi_cache.cpp  (Replace .cpp with protocol file and -o with executable name)
##2 ./proximity_mesi_sim ./benchmarks/benchmark1.txt (Replace benchmark file and executable name)


# Cache Coherence Benchmark Suite

This benchmark suite is designed to evaluate and compare cache coherence protocols such as MESI, MOESI, and Proximity-Aware MESI. Each benchmark stresses different aspects of coherence behavior in shared-memory multiprocessors.

## Benchmarks Overview

### 1. private.txt
**Definition**: Each core accesses a private memory block with a mix of reads and writes.  
**Purpose**: Measures cache hit performance and coherence overhead in workloads with no sharing.  
**Expected Behavior**:
- Very high cache hit rates across all protocols.
- Low invalidations and memory accesses.
- Minimal difference between protocols.

---

### 2. shared_read.txt
**Definition**: Multiple cores read from the same memory address.  
**Purpose**: Highlights the benefits of cache-to-cache transfers and shared data reuse, especially under proximity-aware protocols.  
**Expected Behavior**:
- Baseline MESI may repeatedly fetch from memory.
- Proximity-Aware MESI should achieve more cache-to-cache transfers.
- MOESI will behave similarly to MESI in pure read scenarios.

---

### 3. write_sharing.txt
**Definition**: A mix of read and write accesses to the same address by multiple cores.  
**Purpose**: Simulates producer-consumer sharing; helps evaluate how protocols handle write-sharing and invalidation.  
**Expected Behavior**:
- High invalidation traffic.
- Proximity-Aware MESI may improve read reuse.
- MOESI should outperform MESI by reducing write-backs with the Owned state.

---

### 4. ping_pong.txt
**Definition**: Two cores continuously write to the same memory location in alternation.  
**Purpose**: Stresses the invalidation mechanism and coherence traffic in write-heavy, competitive access patterns.  
**Expected Behavior**:
- High invalidation and latency in MESI.
- MOESI may provide slight relief if Owner state is retained briefly.
- Proximity-Aware MESI unlikely to offer benefit due to frequent ownership changes.

---

### 5. many_sharers.txt
**Definition**: All cores read the same block in a rotating pattern.  
**Purpose**: Evaluates scalability and performance under a high sharer count; good for testing sharer eviction and directory capacity.  
**Expected Behavior**:
- Baseline MESI will show higher memory accesses.
- Proximity-Aware MESI will reuse from nearest sharers.
- Tests directory eviction policies and sharer list limits.

---

### 6. distance_test.txt
**Definition**: Core 0 writes a block periodically; all other cores at varying distances read it.  
**Purpose**: Tests the latency impact of physical distance and validates proximity-aware optimizations.  
**Expected Behavior**:
- Proximity-Aware MESI will show reduced latency for nearby cores.
- MESI and MOESI will not consider distance — uniform latency.
- Effective hit rate will favor proximity-aware protocol.

---

### 7. hybrid.txt
**Definition**: A randomized mix of reads and writes across many cores and addresses.  
**Purpose**: Emulates realistic workloads combining private access, sharing, and contention.  
**Expected Behavior**:
- MOESI expected to perform best overall (due to write efficiency).
- Proximity-Aware MESI will shine in read-sharing.
- Baseline MESI will lag behind in both effective hit rate and latency.

---

## Usage

To run each benchmark:
```bash
./base_mesi_sim benchmarks/<benchmark_file>
./moesi_sim benchmarks/<benchmark_file>
./proximity_mesi_sim benchmarks/<benchmark_file>
```

Compare metrics like:
- Cache-to-cache transfers
- Memory accesses
- Invalidation messages
- Total latency
- Effective hit rate
