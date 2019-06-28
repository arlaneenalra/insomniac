#!/bin/bash

# Mac requires a call prefix to work right.
if [[ "$(uname -s)" == "Darwin" ]]; then
    LLVM_CALL_PREFIX="xcrun" 
fi

PROFDATA="${LLVM_CALL_PREFIX} llvm-profdata"

${PROFDATA} show -all-functions -counts -detailed-summary -ic-targets -memop-sizes -topn=20 "${@}"

