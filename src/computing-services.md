# Deploying services

## Taiga

- [GitHub: docker-taiga](https://github.com/docker-taiga/taiga)
- [Docs: production](https://docs.taiga.io/setup-production.html#_get_repository)
- [Taiga 30min setup](https://community.taiga.io/t/taiga-30min-setup/170)

```bash
#
```
## Jupyterhub

[jupyterhub/jupyterhub: Multi-user server for Jupyter notebooks](https://github.com/jupyterhub/jupyterhub)
[Step-by-Step: Build a Multi-User JupyterLab Server on Ubuntu with Docker & NVIDIA GPU For Machine Learning - PM Square Soft](https://pmsquaresoft.com/machine-learning-jupyterlab-docker-ubuntu-gpu-multiple-users/)
[Installing the NVIDIA Container Toolkit — NVIDIA Container Toolkit](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html#with-dnf-rhel-centos-fedora-amazon-linux)

```dockerfile
FROM quay.io/jupyterhub/jupyterhub

COPY jupyterhub_config.py .
```

```yaml
version: "3"

services:
  jupyterhub:
    image: jupyterhub/jupyterhub:latest
    container_name: jupyterhub
    restart: always
    ports:
      - "8000:8000"
    volumes:
      - ./jupyterhub_config.py:/srv/jupyterhub/jupyterhub_config.py
      - shared-data:/srv/shared   # shared space
      - user-data:/home           # persistent user homes (optional)
    environment:
      DOCKER_JUPYTER_IMAGE: jupyter/base-notebook:latest
      DOCKER_NETWORK_NAME: jupyterhub_network
    networks:
      - jupyterhub_network

volumes:
  shared-data:
  user-data:

networks:
  jupyterhub_network:
    driver: bridge
```

```python
c = get_config()

from dockerspawner import DockerSpawner

c.JupyterHub.spawner_class = DockerSpawner
c.DockerSpawner.image = "jupyter/base-notebook:latest"

# Mount shared volume into every user container
c.DockerSpawner.volumes = {
    "shared-data": "/srv/shared",   # shared across all users
    "user-{username}": "/home/jovyan/work"  # per-user space
}

# Authentication (simple PAM, or plug in LDAP/OAuth)
c.JupyterHub.authenticator_class = "jupyterhub.auth.PAMAuthenticator"
```

```bash
docker-compose up -d
```

```bash
#
```