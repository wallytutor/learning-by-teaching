#!/usr/bin/env bash

# Avoid the following warning:  WARN[0000] "/" is not a shared mount, this
# could cause issues or missing mounts with rootless containers.
sudo mount --make-rshared /

CONTAINER=/usr/bin/podman

OF12R9=openfoam12-rockylinux9

${CONTAINER} build -t "${OF12R9}" -f Containerfile-rockylinux-9 .

${CONTAINER} export -o "${OF12R9}.tar" "${OF12R9}"

apptainer build "${OF12R9}.sif" "docker-archive://${OF12R9}.tar"

# After making sure it is working, remove the image:
# ${CONTAINER} rmi "${OF12R9}"
