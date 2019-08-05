# An incomplete base Docker image for running JupyterHub
#
# Add your configuration to create a complete derivative Docker image.
#
# Include your configuration settings by starting with one of two options:
#
# Option 1:
#
# FROM jupyterhub/jupyterhub:latest
#
# And put your configuration file jupyterhub_config.py in /srv/jupyterhub/jupyterhub_config.py.
#
# Option 2:
#
# Or you can create your jupyterhub config and database on the host machine, and mount it with:
#
# docker run -v $PWD:/srv/jupyterhub -t jupyterhub/jupyterhub
#
# NOTE
# If you base on jupyterhub/jupyterhub-onbuild
# your jupyterhub_config.py will be added automatically
# from your docker directory.

FROM ubuntu:18.04
LABEL maintainer="Jupyter Project <jupyter@googlegroups.com>"

# install nodejs, utf8 locale, set CDN because default httpredir is unreliable
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get -y update && \
    apt-get -y upgrade && \
    apt-get -y install wget git bzip2 sssd-tools python-pip ipython python-ipykernel python-ipython fonts-dejavu unixodbc unixodbc-dev r-cran-rodbc gfortran gcc && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

# install Python + NodeJS with conda
RUN wget -q https://repo.continuum.io/miniconda/Miniconda3-4.7.10-Linux-x86_64.sh -O /tmp/miniconda.sh  && \
    echo '1c945f2b3335c7b2b15130b1b2dc5cf4 */tmp/miniconda.sh' | md5sum -c - && \
    bash /tmp/miniconda.sh -f -b -p /opt/conda && \
    /opt/conda/bin/conda install --yes -c conda-forge \
      python=3.6 sqlalchemy tornado notebook jupyterlab jinja2 traitlets requests pip jupytext pycurl \
      r-base=3.5.1 r-rodbc=1.3* unixodbc=2.3.* r-irkernel=0.8* r-plyr=1.8* r-devtools=2.0* r-tidyverse=1.2* \
      r-shiny=1.2* r-rmarkdown=1.11* r-forecast=8.2* r-rsqlite=2.1* r-reshape2=1.4* r-nycflights13=1.0* r-caret=6.0* r-rcurl=1.95* \
      r-crayon=1.3* r-randomforest=4.6* r-htmltools=0.3* r-sparklyr=0.9* r-htmlwidgets=1.2* r-hexbin=1.27* \
      nodejs configurable-http-proxy && \
    /opt/conda/bin/pip install --upgrade pip && \
    rm /tmp/miniconda.sh
ENV PATH=/opt/conda/bin:$PATH

ADD . /src/jupyterhub
WORKDIR /src/jupyterhub

RUN pip install . && \
    rm -rf $PWD ~/.cache ~/.npm

ADD mods/auth.py /opt/conda/lib/python3.6/site-packages/jupyterhub/auth.py
ADD mods/spawner.py /opt/conda/lib/python3.6/site-packages/jupyterhub/spawner.py
ADD mods/kernel.json /opt/conda/share/jupyter/kernels/ir/kernel.json

RUN pip2 uninstall ipykernel && \
    pip2 install ipykernel && \
    python2 -m ipykernel install --name python2

RUN jupyter nbextension install --py jupytext && \ 
    jupyter nbextension enable --py jupytext && \
    jupyter lab build && \
    jupyter labextension install jupyterlab-jupytext

RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

LABEL org.jupyter.service="jupyterhub"

CMD ["jupyterhub"]
