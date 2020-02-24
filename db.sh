#!/usr/bin/env bash

# input=" -s 220 -i 5 -r 11 -b 0 -c 64 -p"
bench_dir="benchmarks/amg"
input_small=" -problem 2 -n 120 120 120"

gdb ${bench_dir}/transformed -ex 'set env LD_PRELOAD=/home/bkammerd/hmalloc-profile/env/lib/libhmalloc.so' -ex 'set env HMALLOC_PROFILE=yes HMALLOC_SITE_LAYOUT=thread' -ex "run ${input}"
