BENCH_LANG="cxx"

function do_bench_build {
    cd src
    make clean
    make -j $(corecount)
    cp lulesh2.0 ../exe
}
