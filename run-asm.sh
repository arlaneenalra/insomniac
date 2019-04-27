#!/bin/bash
RPATH="-rpath build/src/libinsomniac_runtime -rpath build/src/libinsomniac_buffer -rpath build/src/libinsomniac_gc -rpath build/src/libinsomniac_vm -rpath build/src/libinsomniac_hash -rpath build/src/libinsomniac_vm/libinsomniac_vm_instructions"
LD_PATH="-L  build/src/libinsomniac_runtime -L  build/src/libinsomniac_buffer -L  build/src/libinsomniac_gc -L  build/src/libinsomniac_vm -L  build/src/libinsomniac_hash -L  build/src/libinsomniac_vm/libinsomniac_vm_instructions"

build/src/insc-bootstrap $1 -o scheme.s
as scheme.s -o scheme.o
#ld -lSystem -lc  -linsomniac_runtime -linsomniac_hash -linsomniac_buffer -linsomniac_gc -linsomniac_vm ${LD_PATH} ${RPATH} -e _main -o runme scheme.o
ld -lSystem -lc  -linsomniac_runtime -linsomniac_hash -linsomniac_buffer -linsomniac_gc ${LD_PATH} ${RPATH} -e _main -o runme scheme.o
