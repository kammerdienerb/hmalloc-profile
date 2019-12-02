#!/usr/bin/env bash


# build_llvm="yes"
# build_flang_driver="yes"
# build_openmp="yes"
# build_libpgmath="yes"
# build_flang="yes"
build_hmalloc="yes"
# build_compass="yes"

script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

source ${script_dir}/env/scripts/util.sh

cd "$script_dir"
mkdir -p build
install_dir=$(abspath ./env)

ncores=$(corecount)

### Check versions. ###
function version_gt() { test "$(printf '%s\n' "$@" | sort -V | head -n 1)" != "$1"; }

# CMake 3.4.3
min_cmake="3.4.3"
if [ "$(which cmake)" != "" ]; then
    cmake_ver=$(cmake --version | awk '{ if (NR==1) print $3 }')
    if ! version_gt "$cmake_ver" "$min_cmake"; then
        echo "CMake version ${min_cmake} or greater is required.."
        echo "    found version ${cmake_ver}."
        hm_err "build.sh" "Dependency error."
    fi
else
    echo "CMake version ${min_cmake} or greater is required.."
    echo "    did not find 'cmake'."
    hm_err "build.sh" "Dependency error."
fi

# GCC 7.2.0
min_gcc="7.2.0"
if [ "$(which gcc)" != "" ]; then
    gcc_ver=$(gcc -dumpfullversion -dumpversion)
    if ! version_gt "$gcc_ver" "$min_gcc"; then
        echo "gcc version ${min_gcc} or greater is required.."
        echo "    found version ${gcc_ver}."
        hm_err "build.sh" "Dependency error."
    fi
else
    echo "gcc version ${min_gcc} or greater is required.."
    echo "    did not find 'gcc'."
    hm_err "build.sh" "Dependency error."
fi

### Update repos. ###
git submodule update --init --remote
(cd llvm;         git checkout release_70)
(cd flang-driver; git checkout release_70)
(cd compass;      git checkout hmalloc)

### Build LLVM ###
if ! [ -z "$build_llvm" ]; then
    cd build
    rm -rf *

    CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${install_dir}             \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                 \
                   -DCMAKE_CXX_COMPILER=g++                          \
                   -DCMAKE_C_COMPILER=gcc                            \
                   -DLLVM_TARGETS_TO_BUILD=X86"

    cmake ${CMAKE_OPTIONS} ../llvm
    make -j${ncores}
    make install

    cd ${script_dir}
fi

### Build the flang driver ###
if ! [ -z "$build_flang_driver" ]; then
    cd build
    rm -rf *

    CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${install_dir}             \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                 \
                   -DCMAKE_CXX_COMPILER=g++                          \
                   -DCMAKE_C_COMPILER=gcc"                           \
                   -DLLVM_CONFIG=${install_dir}/bin/llvm-config"

    cmake ${CMAKE_OPTIONS} ../flang-driver
    make -j${ncores}
    make install

    cd ${script_dir}
fi

### Build OpenMP ###
if ! [ -z "$build_openmp" ]; then
    cd build
    rm -rf *

    CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${install_dir}             \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                 \
                   -DCMAKE_CXX_COMPILER=${install_dir}/bin/clang++   \
                   -DCMAKE_C_COMPILER=${install_dir}/bin/clang       \
                   -DLLVM_CONFIG=${install_dir}/bin/llvm-config"

    cmake ${CMAKE_OPTIONS} ../openmp
    make -j${ncores}
    make install

    cd ${script_dir}
fi

### Build libpgmath ###
if ! [ -z "$build_libpgmath" ]; then
    cd build
    rm -rf *

    CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${install_dir}             \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                 \
                   -DCMAKE_CXX_COMPILER=${install_dir}/bin/clang++   \
                   -DCMAKE_C_COMPILER=${install_dir}/bin/clang       \
                   -DLLVM_CONFIG=${install_dir}/bin/llvm-config"

    cmake ${CMAKE_OPTIONS} ../flang/runtime/libpgmath
    make -j${ncores}
    make install

    cd ${script_dir}
fi

### Build flang ###
if ! [ -z "$build_flang" ]; then
    cd build
    rm -rf *

    CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${install_dir}             \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                 \
                   -DCMAKE_CXX_COMPILER=${install_dir}/bin/clang++   \
                   -DCMAKE_C_COMPILER=${install_dir}/bin/clang       \
                   -DLLVM_CONFIG=${install_dir}/bin/llvm-config"

    cmake ${CMAKE_OPTIONS} ../flang
    make -j${ncores}
    make install

    cd ${script_dir}
fi

### Build hmalloc ###
if ! [ -z "$build_hmalloc" ]; then
    cd hmalloc

    make clean
    make -j${ncores}
    cp lib/libhmalloc.so ${install_dir}/lib

    cd ${script_dir}
fi

### Build compass ###
if ! [ -z "$build_compass" ]; then
    cd build
    rm -rf *

    CMAKE_OPTIONS="-DCMAKE_INSTALL_PREFIX=${install_dir}             \
                   -DCMAKE_BUILD_TYPE=RelWithDebInfo                 \
                   -DCMAKE_CXX_COMPILER=${install_dir}/bin/clang++   \
                   -DCMAKE_C_COMPILER=${install_dir}/bin/clang       \
                   -DLLVM_CONFIG=${install_dir}/bin/llvm-config"

    cmake ${CMAKE_OPTIONS} ../compass
    make -j${ncores}

    cp compass/libcompass.so ${install_dir}/lib

    cd ${script_dir}
fi

rm -rf build
