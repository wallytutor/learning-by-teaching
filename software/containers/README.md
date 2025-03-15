# OpenFOAM containers

## Build

```bash
# Variable with name of container:
R9OF12=rockylinux9-openfoam12

# Avoid the following warning:  WARN[0000] "/" is not a shared mount, this
# could cause issues or missing mounts with rootless containers.
sudo mount --make-rshared /

# Build the container image:
/usr/bin/podman build -t "${R9OF12}" -f "Containerfile-${R9OF12}" .

# Save container to portable .tar:
/usr/bin/podman save -o "${R9OF12}.tar" "localhost/${R9OF12}"

# Convert container to 
/usr/bin/apptainer build "${R9OF12}.sif" "docker-archive://${R9OF12}.tar"

# After making sure it is working, remove the image:
/usr/bin/podman rmi "${R9OF12}"
```

## Usage

Append the following lines to your `.bashrc` file:

```bash
FOAM_SOURCE=/opt/openfoam12/OpenFOAM-12/etc/bashrc

[[ -f ${FOAM_SOURCE} ]] && source ${FOAM_SOURCE}
```

Open a new terminal or `source ~/.bashrc` and run:

```bash
apptainer run /<path>/<to>/openfoam12-rockylinux9.sif
```
