# Containers

## Using Podman

In the open source community [podman](https://podman.io/) takes the place of [docker](https://www.docker.com/) for the creation of application containers. It mimics the commercial software to allow developers work with both tools *almost* interchangeably. It is not uncommon to find people creating aliases of `docker` in their sandbox environments to point to their `podman` executable. One must be aware that although the command interfaces are very similar, they are not the *exactly* same and advance usage requires mastering each of them individually.

The following summarizes some daily life commands with `podman`.

- List available images in a local machine:

```bash
podman images
```

- Run image `<img>` interactively using bash:

```bash
podman run -it <img> /bin/bash
```

- Dump image `<img>` to `<img>.tar` for portability:

```bash
podman save -o <img>.tar <img>
```

- List all available containers (there might be external/hidden, so use `-a`):

```bash
podman container ls -a
```

- Remove a given container by ID (only the first 2-3 characters of ID are required):

```bash
podman container rm <ID>
```

- Remove a given image by ID:

```bash
podman rmi <ID>
# podman image rm <ID>
```

## Using Apptainer

Using `podman` locally is great, but packaging redistributable containers for reuse in HPC is much smoother with [Apptainer](https://apptainer.org/). The tool started at [Lawrence Berkeley National Laboratory](https://www.lbl.gov/) can be [downloaded](https://github.com/apptainer/apptainer/releases) for several Linux systems and deployed locally. Under Debian (or its variants, as Ubuntu), navigate to the download directory and install with the following, taking care to replace the right version:

```shell
export APPTAINER_VERSION=1.3.6_amd64.deb

sudo dpkg -i apptainer_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-dbgsym_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-suid_${APPTAINER_VERSION}
# sudo dpkg -i apptainer-suid-dbgsym_${APPTAINER_VERSION}
```

- Converting a local `podman` dump into a Singularity image:

```bash
apptainer build "<img>.sif" "docker-archive://<img>.tar"
```

- Running an `apptainer` image as a non-root user is as simple as:

```bash
apptainer run <img>.sif
```

## Apptainer and environment

Since `apptainer` makes use of *user space*, sourcing of applications is not done as root, so one must edit add to their `~/.bashrc` if path configuration is desired and re-source that file when activating a container. For instance, the required environment variables for #OpenFOAM are provided `FOAM_SOURCE` file given below; in the *host system* outside the container it does not exist, so adding a test in `~/.bashrc` is required. Once you activate the container with `apptainer run <image-name>.sif`, by calling `source ~/.bashrc` the environment will be properly set.

```bash
FOAM_SOURCE=/opt/openfoam12/OpenFOAM-12/etc/bashrc

[[ -f ${FOAM_SOURCE} ]] && source ${FOAM_SOURCE}
```

Another approach is to execute the SIF image once, source the required variables required in the container, dump `env > draft.env`, [edit the file](https://github.com/wallytutor/learning-by-teaching/blob/main/containers/clean-env.py) as required and then wrap a call with contextualized environment as:

```bash
function openfoam12() {
	FOAM_NAME=$HOME/Applications/openfoam12-rockylinux9
	apptainer run --cleanenv --env-file ${FOAM}.env ${FOAM}.sif
}
```

## Build workflow

Using both tools can be roughly automated by generating a `podman` image, dumping it into a portable format, then converting to Singularity format. Below we illustrate the workflow for [this OpenFOAM Containerfile](https://github.com/wallytutor/learning-by-teaching/blob/main/software/containers/Containerfile-rockylinux9-openfoam12):

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

Now you can move the SIF image to another computer (for instance, you prepared this in a PC with access to the Internet to later use it in an isolated HPC), open a new terminal or `source ~/.bashrc` and run:

```bash
apptainer run /<path>/<to>/openfoam12-rockylinux9.sif
```

**Note:** use `apptainer run` when you want to execute the container's default application or task; on the other hand, use `apptainer shell` when you need an interactive session to explore or debug the container. For the OpenFOAM example above, both are very similar as no default application is launched, but a shell session itself.
