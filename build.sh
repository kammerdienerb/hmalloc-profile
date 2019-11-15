#!/usr/bin/env bash

### Update repos. ###

git submodule update --init --remote

### Check versions. ###

function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# CMake 3.4.3
min_cmake="3.4.3"
if [ "$(which cmake)" != "" ]; then
    cmake_ver=$(cmake --version | awk '{ if (NR==1) print $3 }')
    if ! version_gt "$cmake_ver" "$min_cmake"; then
        echo "CMake version ${min_cmake} is required.."
        echo "    found version ${cmake_ver}."
        exit 1
    fi
else
    echo "CMake version ${min_cmake} is required.."
    echo "    did not find 'cmake'."
    exit 1
fi

# GCC 7.2.0
min_gcc="7.2.0"
if [ "$(which gcc)" != "" ]; then
    gcc_ver=$(gcc -dumpversion)
    if ! version_gt "$gcc_ver" "$min_gcc"; then
        echo "gcc version ${min_gcc} is required.."
        echo "    found version ${gcc_ver}."
        exit 1
    fi
else
    echo "gcc version ${min_gcc} is required.."
    echo "    did not find 'gcc'."
    exit 1
fi
