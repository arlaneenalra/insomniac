#!/bin/sh
#echo "Cleaning . . ."
#make clean
#echo

echo "Source Statistics:"
wc `find ./src ./lib -type f | grep -v 'test\/test_eyeball\|CMake\|build/\|\.*.txt\|\.*.swp\|.*log'` | sort -n

echo
echo "Commit Count: " `git log | grep '^commit' | wc -l`
echo
