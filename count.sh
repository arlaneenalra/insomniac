#!/bin/sh
#echo "Cleaning . . ."
#make clean
#echo

echo "Source Statistics:"
wc `find ./src ./asm -regextype posix-basic -iregex '.*\.\(asm\|scm\|h\|c\|y\|l\)' | grep -v 'test\/test_eyeball\|CMake\|build/'`

echo
echo "Commit Count: " `git log | grep '^commit' | wc -l`
echo
