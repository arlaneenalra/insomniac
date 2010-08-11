#!/bin/sh

TARGET=build

echo 'Setting up an out of source build tree:'
if [ ! -d $TARGET ] ; then 
	echo "\tCreating Directory: $TARGET"
	mkdir $TARGET
fi

cd $TARGET

echo "\tRunning cmake"
cmake ..

echo 'Done.'
