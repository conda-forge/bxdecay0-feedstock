#!/usr/bin/env bash

set -o xtrace -o nounset -o pipefail -o errexit

cmake -S . -B build \
    -D CMAKE_BUILD_TYPE="Release" \
    -D CMAKE_INSTALL_PREFIX="${PREFIX}" \
    -D BUILD_TESTING=ON \
    -D BXDECAY0_WITH_GEANT4_EXTENSION=ON \
    ${CMAKE_ARGS} \
    "${SRC_DIR}"

cmake --build build -j${CPU_COUNT}

# Skip ``ctest`` when cross-compiling
if [[ "${CONDA_BUILD_CROSS_COMPILATION:-}" != "1" || "${CROSSCOMPILING_EMULATOR:-}" != "" ]]; then
    ctest -V --test-dir build
fi

cmake --install build
