#!/usr/bin/env bash

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${this_dir}/check_env.sh"
source "${this_dir}/util.sh"

if [ -z "${BENCH_DIR}" ]; then
    hm_err "bench_run.sh" "BENCH_DIR is not set."
fi

if ! [ -f "${BENCH_DIR}/bench_run.sh" ]; then
    hm_err "bench_run.sh" "${BENCH_DIR}/bench_run.sh not found."
fi

source ${BENCH_DIR}/bench_run.sh

if ! [ "$(type -t do_bench_run 2>/dev/null)" = "function" ]; then
    hm_err "bench_run.sh" "Missing bash function 'do_bench_run' from '${BENCH_DIR}/bench_run.sh'."
fi

control="./control "
jemalloc="env LD_PRELOAD=/usr/lib64/libjemalloc.so ./control"
hmalloc="env LD_PRELOAD=${HMALLOC_ENV_DIR}/lib/libhmalloc.so HMALLOC_PROFILE=yes ./transformed"

if ! [ "$1" = "control" ] && ! [ "$1" = "jemalloc" ] && ! [ "$1" = "hmalloc" ]; then
    hm_err "bench_run.sh" "Invalid run config '$1'."
fi

if ! [ "$2" = "small" ] && ! [ "$2" = "medium" ] && ! [ "$2" = "large" ]; then
    hm_err "bench_run.sh" "Invalid input size '$2'."
fi

input_name="input_$2"
export CMD="${!1} ${!input_name}"

cd ${BENCH_DIR}

rm -f hmalloc.profile
mkdir -p results/$2

export output_file=results/$2/$1.stdout

function run_prepared_cmd {
    script -q -c "/usr/bin/time -v ${CMD}" /dev/null 2>&1 | tee ${output_file}
}

echo $CMD
do_bench_run

if [ "$1" = "hmalloc" ]; then
    mv hmalloc.profile results/$2/hmalloc.profile.csv
fi
