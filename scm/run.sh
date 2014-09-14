#!/bin/bash

# see: http://stackoverflow.com/a/17076258
function abs_path {
  (cd "$(dirname '$1')" &>/dev/null && printf "%s/%s" "$(pwd)" "${1##*/}")
}

TMP=`mktemp`
SRC=$(abs_path $1)

echo $TMP

echo
echo "Compiling ..."
echo

# the compiler needs to know where to find it's preamble
(
  cd ../build
  src/insc $SRC > $TMP
)

#cat ../asm/stack_dumper.asm >> $TMP

echo
echo
echo "Running ..."
echo

../build/src/insomniac $TMP

echo
echo

rm $TMP
