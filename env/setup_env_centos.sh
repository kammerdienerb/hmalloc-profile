#!/usr/bin/env bash

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/scripts/util.sh

if [ "$(which cmake3)" == "" ]; then
    echo "A cmake3 executable is required.."
    echo "    Please install cmake3."
    hm_err "setup_env_centos.sh" "Dependency error."
fi

if ! scl --list | grep "devtoolset-7" 2>&1 > /dev/null; then
    echo "devtoolset-7 is required.."
    echo "    Please install devtoolset-7."
    hm_err "setup_env_centos.sh" "Dependency error."
fi

if ! [ -f ${script_dir}/bin/cmake ]; then
    mkdir -p ${script_dir}/bin
    ln -s $(which cmake3) ${script_dir}/bin/cmake
fi

scl enable devtoolset-7 ${script_dir}/setup_env.sh
