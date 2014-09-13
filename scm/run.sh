#!/bin/bash

TMP=`mktemp`

echo $TMP

echo
echo "Compiling ..."
echo

../build/src/insc $1 | tee $TMP

cat ../asm/stack_dumper.asm >> $TMP

echo
echo
echo "Running ..."
echo

../build/src/insomniac $TMP
echo
echo

rm $TMP
