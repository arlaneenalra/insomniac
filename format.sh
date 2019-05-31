#!/bin/bash

clang-format -i -style=file $(find ./src/ -name '*.c';  find ./src/ -iname '*.h' )

