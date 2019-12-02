BENCH_LANG="c"

function do_bench_build {
    ${COMPILER_WRAPPER} -c -O0 test.c -o test.o
    ${LD_WRAPPER} test.o -lpthread -o test

    mv test exe
}
