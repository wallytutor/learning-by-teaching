# Deploying services

## Taiga

- [GitHub: docker-taiga](https://github.com/docker-taiga/taiga)
- [Docs: production](https://docs.taiga.io/setup-production.html#_get_repository)
- [Taiga 30min setup](https://community.taiga.io/t/taiga-30min-setup/170)

```bash
#
```
## Jupyterhub

### Useful links

- [Step-by-step tutorial](https://pmsquaresoft.com/machine-learning-jupyterlab-docker-ubuntu-gpu-multiple-users/)
- Ensure installation of [NVIDIA container toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#with-dnf-rhel-centos-fedora-amazon-linux)
- Clone [Jupyterhub repository](https://github.com/jupyterhub/jupyterhub) for reference

### Deployment checklist

Simple workflow adapted from [jupyterhub/jupyterhub-deploy-docker](https://github.com/jupyterhub/jupyterhub-deploy-docker/tree/main).

- Create a docker file with the minimum (consider pinning a version as below):

```dockerfile
FROM quay.io/jupyterhub/jupyterhub:5.4.0

RUN python3 -m pip install --no-cache-dir \
    dockerspawner \
    jupyterhub-nativeauthenticator

CMD ["jupyterhub", "-f", "/srv/jupyterhub/jupyterhub_config.py"]
```

- Create a minimal docker-compose file with the following and `docker compose build`

```yaml
services:
  hub:
    build:
      context: .
      dockerfile: Dockerfile
    restart: always
    image: jupyterhub
    container_name: jupyterhub
    networks:
      - jupyterhub-network
    volumes:
      - "./jupyterhub_config.py:/srv/jupyterhub/jupyterhub_config.py:ro"
      - "/var/run/docker.sock:/var/run/docker.sock:rw"
      - "jupyterhub-data:/mnt/beegfs/services/data/JUPYTER/shared"
      - "user-data:/home_nfs"
    ports:
      - "8000:8000"
    environment:
      JUPYTERHUB_ADMIN: walter
      DOCKER_NETWORK_NAME: jupyterhub-network
      DOCKER_NOTEBOOK_IMAGE: quay.io/jupyter/base-notebook:latest
      DOCKER_NOTEBOOK_DIR: /home/jovyan/work

volumes:
  jupyterhub-data:
  user-data:

networks:
  jupyterhub-network:
    name: jupyterhub-network
```

- Create a configuration file as:

```python
# -*- coding: utf-8 -*-
import os

c = get_config()  # noqa: F821

# We rely on environment variables to configure JupyterHub so that we
# avoid having to rebuild the JupyterHub container every time we change a
# configuration parameter.

# Spawn single-user servers as Docker containers
c.JupyterHub.spawner_class = "dockerspawner.DockerSpawner"

# Spawn containers from this image
c.DockerSpawner.image = os.environ["DOCKER_NOTEBOOK_IMAGE"]

# Connect containers to this Docker network
network_name = os.environ["DOCKER_NETWORK_NAME"]
c.DockerSpawner.use_internal_ip = True
c.DockerSpawner.network_name = network_name

# Explicitly set notebook directory because we'll be mounting a volume to it.
# Most `jupyter/docker-stacks` *-notebook images run the Notebook server as
# user `jovyan`, and set the notebook directory to `/home/jovyan/work`.
# We follow the same convention.
notebook_dir = os.environ.get("DOCKER_NOTEBOOK_DIR", "/home/jovyan/work")
c.DockerSpawner.notebook_dir = notebook_dir

# Mount the real user's Docker volume on the host to the notebook user's
# notebook directory in the container
# c.DockerSpawner.volumes = {"jupyterhub-user-{username}": notebook_dir}

c.DockerSpawner.volumes = {
    "jupyterhub-data": f"{notebook_dir}/shared",
    "jupyterhub-user-{username}": notebook_dir
}

# Remove containers once they are stopped
c.DockerSpawner.remove = True

# For debugging arguments passed to spawned containers
c.DockerSpawner.debug = True

# User containers will access hub by container name on the Docker network
c.JupyterHub.hub_ip = "jupyterhub"
c.JupyterHub.hub_port = 5001
c.JupyterHub.hub_bind_url = 'http://jupyterhub:5001'
c.JupyterHub.bind_url = 'http://0.0.0.0:8000'


# Persist hub data on volume mounted inside container
c.JupyterHub.cookie_secret_file = "/mnt/beegfs/services/data/JUPYTER/shared/jupyterhub_cookie_secret"
c.JupyterHub.db_url = "sqlite:////mnt/beegfs/services/data/JUPYTER/shared/jupyterhub.sqlite"

# Allow all signed-up users to login
c.Authenticator.allow_all = True

# Authenticate users with Native Authenticator
c.JupyterHub.authenticator_class = "nativeauthenticator.NativeAuthenticator"

# Allow anyone to sign-up without approval
c.NativeAuthenticator.open_signup = True

# Allowed admins
admin = os.environ.get("JUPYTERHUB_ADMIN")
if admin:
    c.Authenticator.admin_users = [admin]
```



```bash
docker-compose up -d
docker-compose down
```

```bash
#
```