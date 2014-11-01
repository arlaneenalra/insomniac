#!/bin/sh

TARGET=build

echo 'Setting up an out of source build tree:'
if [ ! -d $TARGET ] ; then 
	echo "	Creating Directory: $TARGET"
	mkdir $TARGET
fi

cd $TARGET

# setup some needed directories
if [ ! -x "lib" ] ; then
  ln -s ../lib lib
fi

## check for homebrewed bison packaged with braindead xcode
#HOMEBREW_BISON=/usr/local/opt/bison/bin/
#if [ -x "$HOMEBREW_BISON/bison" ] ; then
#  PATH=$HOMEBREW_BISON:$PATH
#fi
#
echo "	Running cmake"
cmake ..

echo 'Done.'
