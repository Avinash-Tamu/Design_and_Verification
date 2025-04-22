#!/bin/bash

# Usage: ./run_all_benchmarks.sh ./proximity_mesi_sim

if [ -z "$1" ]; then
  echo "Usage: $0 path_to_executable"
  exit 1
fi

EXEC=$1
BENCH_DIR="benchmarks"

for file in $BENCH_DIR/*.txt; do
  echo "============================"
  echo "Running benchmark: $file"
  echo "============================"
  $EXEC "$file"
  echo
done
