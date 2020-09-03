### Usage

```
docker pull mpgagebioinformatics/jupyter-age:latest
mkdir -p ${HOME}/jupyter-age/jupyter/ ${HOME}/jupyter-age/data/
docker run -v ${HOME}/jupyter-age/jupyter/:/root/.jupyterhub/ -v ${HOME}/jupyter-age/data/:/srv/jupyterhub/ -p 8081:8000 -it mpgagebioinformatics/jupyter-age:latest /bin/bash
jupyter lab --ip=0.0.0.0 --port=8000 --allow-root
```

A link of the type http://127.0.0.1:8000/?token=e8a687aa90fca358de6ce6b8a8ea802d11b257dd63a41eef will be shown to you. Replace the port and an ip so that it looks like this - http://0.0.0.0:8081/?token=e8a687aa90fca358de6ce6b8a8ea802d11b257dd63a41eef and use this link to access jupyter lab.

All installed Python and R packages will me stored on your hosts `${HOME}/jupyter-age/jupyter/` while data that you might wish to use will need to be in `${HOME}/jupyter-age/data/`.

### Known issues

Several packages have data installed in `/root/` as this is the path to root's home folder.

