ITERS=5

input_small=" -s 220 -i $ITERS -r 11 -b 0 -c 64 -p"
input_medium="-s 340 -i $ITERS -r 11 -b 0 -c 64 -p"
input_large=" -s 420 -i $ITERS -r 11 -b 0 -c 64 -p"

function do_bench_run {
    run_prepared_cmd
}
