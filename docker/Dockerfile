FROM ubuntu:latest

RUN apt update && apt -y dist-upgrade && apt -y install flex bison cmake lldb \
    && rm -rf /var/lib/apt/lists/*

ENV TARGET=build-docker

