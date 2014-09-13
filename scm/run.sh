#!/bin/bash

TMP=`mktemp`


echo
echo "Compiling ..."
echo

../build/src/insc $1 | tee $TMP

echo " out" >> $TMP

echo
echo
echo "Running ..."
echo

../build/src/insomniac $TMP
echo
echo

