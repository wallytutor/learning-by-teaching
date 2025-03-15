#!/usr/bin/env bash

build_image() {
    podman build -t $1 -f $2 .
}

run_container() {
    podman run -it $1 /bin/bash
}
