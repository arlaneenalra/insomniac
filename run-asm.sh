#!/bin/bash
set -e

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]:-$0}"; )" &> /dev/null && pwd 2> /dev/null; )"


BUILD_DIR="${SCRIPT_DIR}/build"

RPATH="-rpath ${BUILD_DIR}/src/libinsomniac_runtime -rpath ${BUILD_DIR}/src/libinsomniac_buffer -rpath ${BUILD_DIR}/src/libinsomniac_gc -rpath ${BUILD_DIR}/src/libinsomniac_vm -rpath ${BUILD_DIR}/src/libinsomniac_hash -rpath ${BUILD_DIR}/src/libinsomniac_vm/libinsomniac_vm_instructions"
LD_PATH="-L ${BUILD_DIR}/src/libinsomniac_runtime -L ${BUILD_DIR}/src/libinsomniac_buffer -L ${BUILD_DIR}/src/libinsomniac_gc -L ${BUILD_DIR}/src/libinsomniac_vm -L ${BUILD_DIR}/src/libinsomniac_hash -L ${BUILD_DIR}/src/libinsomniac_vm/libinsomniac_vm_instructions"

LD=ld
AS=as

if [[ "$(uname -s)" == "Darwin" ]]; then
  SDK_PATH=$(xcrun --show-sdk-path)

  LD=$(xcrun --find ld)
  AS=$(xcrun --find as)
  LD_PATH="-L ${SDK_PATH}/usr/lib ${LD_PATH}"

fi
build/src/insc-bootstrap $1 -o scheme.s --home ${SCRIPT_DIR}/src

${AS} scheme.s -o scheme.o
#ld -lSystem -lc  -linsomniac_runtime -linsomniac_hash -linsomniac_buffer -linsomniac_gc -linsomniac_vm ${LD_PATH} ${RPATH} -e _main -o runme scheme.o
#ld -lSystem -lc  -linsomniac_runtime -linsomniac_hash -linsomniac_buffer -linsomniac_gc ${LD_PATH} ${RPATH} -e _main -o runme scheme.o
${LD} ${LD_PATH} ${RPATH} -lSystem -lc  -linsomniac_runtime -linsomniac_hash -linsomniac_buffer -linsomniac_gc -linsomniac_vm -e _main -o runme scheme.o
