FROM ubuntu:latest

RUN apt update && apt -y dist-upgrade && apt -y install flex bison cmake lldb gdb \
    && rm -rf /var/lib/apt/lists/*

ENV TARGET=build-docker

