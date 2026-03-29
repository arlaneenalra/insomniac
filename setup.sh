#!/bin/bash

if [[ -z "$TARGET" ]]; then
  TARGET=build
fi

echo 'Setting up an out of source build tree:'
if [[ ! -d $TARGET ]] ; then 
  echo "	Creating Directory: $TARGET"
  mkdir $TARGET
fi

cd $TARGET

# setup some needed directories
if [[ ! -x "src/lib" ]] ; then
  mkdir src    
  ln -s ../../src/lib src/lib
fi

# check for homebrewed bison packaged with braindead xcode
if [[ "$(uname -s)" == "Darwin" ]]; then
  HOMEBREW_BISON=$(brew --prefix bison)/bin
  if [[ -x "$HOMEBREW_BISON/bison" ]] ; then
    PATH=$HOMEBREW_BISON:$PATH
  fi
fi
echo "	Running cmake"
cmake ..

echo 'Done.'
