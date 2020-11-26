# README

### Starting and entering a container on your local computer:
```
docker pull mpgagebioinformatics/jupyter-age:3.0.0
mkdir -p ${HOME}/jupyter-age/jupyter/ ${HOME}/jupyter-age/data/
docker run -v ${HOME}/jupyter-age/jupyter/:/root/.jupyterhub/ -v ${HOME}/jupyter-age/data/:/srv/jupyterhub/ -p 8081:8081 -it mpgagebioinformatics/jupyter-age:3.0.0 /bin/bash
```

Packages will then be kept in `${HOME}/jupyter-age/jupyter/` while data that you work on can be stored in `${HOME}/jupyter-age/data/`.

Starting jupyter lab inside the container:
```
jupyter lab --ip=0.0.0.0 --port=8081 --allow-root
```
A link will then be provided with a token for the address 127.0.0.1.

Using python inside the container:
```
export PYTHONUSERBASE=${HOME}/.jupyterhub/python/
python
```

Using R inside the container (eg. R 4.0.3):
```
conda activate r-4.0.3
R
```

### Using this image with singularity

```
module purge && unset PYTHONHOME PYTHONUSERBASE PYTHONPATH
singularity exec /beegfs/common/singularity/jupyter-age.3.0.0.sif /bin/bash
```

Using python inside the container:
```
export PYTHONUSERBASE=${HOME}/.jupyterhub/python/
python
```

Using R inside the container (eg. R 4.0.3):
```
conda activate r-4.0.3
R
```

### Package mobility 

Packages available in jupyerhub will be directly available when using the image through singularity.

Packages installed when using the image on you local computer can be transferred and used in the server with:
```
rsync -rtvh ${HOME}/jupyter-age/jupyter/* amalia.age.mpg.de:~/.jupyterhub/
```

And vice-versa with 
```
rsync -rtvh amalia.age.mpg.de:~/.jupyterhub/* ${HOME}/jupyter-age/jupyter/
```

# Contributing

`Renviron` files are created by generating the image with the original `Renviron` and collecting it's content. 
Additionally, the respective conda env is activated eg. `conda activate r-4.0.3` and the respective env collected into the `Renviron`.
From this last one a few variables need to be removed eg. `PWD`, `HOSTNAME`. 
Afterwards, the value of each variable is encapsulated in single quotes. 
For r versions bellow 3.6.3 every "=" sign between the single quotes is replaced by a space due to the way R used to interpret the file.