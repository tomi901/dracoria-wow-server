#!/usr/bin/env bash

CUR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
BUILD_PATH="$CUR_PATH/build"

mkdir -p $BUILD_PATH
cd $BUILD_PATH && cmake ../ -DCMAKE_INSTALL_PREFIX=/home/acore/server \
  -DCMAKE_C_COMPILER=/usr/bin/clang -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DWITH_WARNINGS=1 -DTOOLS_BUILD=all -DSCRIPTS=static -DMODULES=static
