#!/usr/bin/env bash

# input=" -s 220 -i 5 -r 11 -b 0 -c 64 -p"
bench_dir=$(realpath "benchmarks/qmcpack")
input=" small.xml"

cd ${bench_dir}/run

LD_PRELOAD=/home/bkammerd/hmalloc-profile/env/lib/libhmalloc.so HMALLOC_PROFILE=yes HMALLOC_SITE_LAYOUT=thread ${bench_dir}/transformed ${input} &
gdb -p $!

wait
