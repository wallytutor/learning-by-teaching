# OpenFOAM containers

## Build

```bash
# Variable with name of container:
OF12R9=openfoam12-rockylinux9

# Avoid the following warning:  WARN[0000] "/" is not a shared mount, this
# could cause issues or missing mounts with rootless containers.
sudo mount --make-rshared /

# Build the container image:
/usr/bin/podman build -t "${OF12R9}" -f Containerfile-rockylinux-9 .

# Save container to portable .tar:
/usr/bin/podman save -o "${OF12R9}.tar" "localhost/${OF12R9}"

# Convert container to 
/usr/bin/apptainer build "${OF12R9}.sif" "docker-archive://${OF12R9}.tar"

# After making sure it is working, remove the image:
/usr/bin/podman rmi "${OF12R9}"
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
