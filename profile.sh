#!/bin/bash
set -e

# Mac requires a call prefix to work right.
if [[ "$(uname -s)" == "Darwin" ]]; then
    LLVM_CALL_PREFIX="xcrun" 
fi

PROFDATA="${LLVM_CALL_PREFIX} llvm-profdata"

LLVM_PROFILE_FILE=$(mktemp)
trap "rm -f ${LLVM_PROFILE_FILE}" EXIT

export LLVM_PROFILE_FILE

LLVM_PROFILE_MERGE="${1}"
shift

# Run the called app.
eval "$@"

${PROFDATA} merge -output=${LLVM_PROFILE_MERGE} ${LLVM_PROFILE_FILE}

