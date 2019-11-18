#!/usr/bin/env bash

this_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source "${this_dir}/check_env.sh"
source "${this_dir}/util.sh"

if [ -z "${BENCH_DIR}" ]; then
    hm_err "bench_build.sh" "BENCH_DIR is not set."
fi

if ! [ -f "${BENCH_DIR}/bench_build.sh" ]; then
    hm_err "bench_build.sh" "${BENCH_DIR}/bench_build.sh not found."
fi

source ${BENCH_DIR}/bench_build.sh

if [ -z "${BENCH_LANG}" ]; then
    hm_err "bench_build.sh" "BENCH_LANG is not set."
fi

if [ "${BENCH_LANG}" = "fort" ]; then
    export LD_LINKER="flang"
elif [ "${BENCH_LANG}" = "c" ]; then
    export LD_LINKER="clang"
elif [ "${BENCH_LANG}" = "cxx" ]; then
    export LD_LINKER="clang++"
else
    hm_err "bench_build.sh" "Invalid BENCH_LANG \'${BENCH_LANG}\'."
fi

if ! [ "$(type -t do_bench_build 2>/dev/null)" = "function" ]; then
    hm_err "bench_build.sh" "Missing bash function 'do_bench_build' from '${BENCH_DIR}/bench_build.sh'."
fi

cd ${BENCH_DIR}

# Define the variables for the compiler wrappers
export LD_COMPILER="clang++" # Compiles from .bc -> .o
export CXX_COMPILER="clang++"
export FORT_COMPILER="flang"
export C_COMPILER="clang"
export LLVMLINK="llvm-link"
export LLVMOPT="opt"

export COMPILER_WRAPPER="${LD_LINKER} -I${HMALLOC_ENV_DIR}/include"
export LD_WRAPPER="${LD_LINKER} -L${HMALLOC_ENV_DIR}/lib -lhmalloc "
export PREPROCESS_WRAPPER="${LD_LINKER} -E -x c -P"
export AR_WRAPPER="ar"
export RANLIB_WRAPPER="ranlib"

(do_bench_build)

mv exe control

# Make sure the Makefiles find our wrappers
export COMPILER_WRAPPER="compiler_wrapper.sh -I${HMALLOC_ENV_DIR}/include"
export LD_WRAPPER="ld_wrapper.sh "
export PREPROCESS_WRAPPER="clang -E -x c -P"
export AR_WRAPPER="ar_wrapper.sh"
export RANLIB_WRAPPER="ranlib_wrapper.sh"

(do_bench_build)

mv exe transformed
