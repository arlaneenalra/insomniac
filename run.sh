#!/bin/bash

# see: http://stackoverflow.com/a/17076258
function abs_path {
  (cd "$(dirname '$1')" &>/dev/null && printf "%s/%s" "$(pwd)" "${1##*/}")
}

realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}


DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SAVE=$2

if [ "$SAVE" == "" ] ; then
  TMP=`mktemp -t insomniac.XXXXXXXXXX`
else 
  TMP=$(abs_path $SAVE)
fi

SRC=$(realpath $1)

(
  cd $DIR

  echo "Temp :" $TMP 

  echo
  echo "Compiling ..."
  echo

  build/src/insc --no-assemble $SRC $TMP

  EXIT=$?

  if [ "$EXIT" != "0" ] ; then
    exit $EXIT 
  fi


  echo
  echo
  echo "Running ..."
  echo

  build/src/insomniac $TMP

  EXIT=$?

  if [ "$EXIT" != "0" ] ; then
    exit $EXIT 
  fi
)

EXIT=$?

echo
echo

if [ "$SAVE" == "" ] && [ "$TMP" != "" ]  ; then
  rm $TMP
fi

if [ "$EXIT" != "0" ] ; then
  echo "Exit status:" $EXIT
  exit $EXIT 
fi

