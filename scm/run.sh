#!/bin/bash

# see: http://stackoverflow.com/a/17076258
function abs_path {
  (cd "$(dirname '$1')" &>/dev/null && printf "%s/%s" "$(pwd)" "${1##*/}")
}

SAVE=$2

if [ "$SAVE" == "" ] ; then
  TMP=`mktemp`
else 
  TMP=$(abs_path $SAVE)
fi

SRC=$(abs_path $1)

(
  echo $TMP

  echo
  echo "Compiling ..."
  echo

  # the compiler needs to know where to find it's preamble
  (
    cd ../build
    src/insc $SRC > $TMP
  )

  EXIT=$?

  if [ "$EXIT" != "0" ] ; then
    echo $EXIT
    exit $EXIT 
  fi


  echo
  echo
  echo "Running ..."
  echo

  ../build/src/insomniac $TMP

)

echo
echo

if [ "$SAVE" == "" ] ; then
  rm $TMP
fi
