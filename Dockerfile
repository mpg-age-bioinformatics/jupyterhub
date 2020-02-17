# Try to generate seperate layers
# Use hub.age.mpg.de/rstudio:3.5.3 as baseimage as we want to use the same R version on both interfaces 
ARG BASE_CONTAINER=hub.age.mpg.de/rstudio:3.6.1
FROM $BASE_CONTAINER
LABEL maintainer="Daniel Rosskopp <drosskopp@upcal.de>"

## Integrate jupiter/docker-stacks/base-notbook with mods

USER root

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
	bzip2 \
	fonts-liberation && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV LANG C.UTF-8

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

# Set env for installing miniconda
ENV MINICONDA_VERSION=latest \
    #CONDA_VERSION=4.7.10 \
	CONDA_DIR=/opt/conda \
	SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

# Install miniconda
RUN cd /tmp && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    #echo "718259965f234088d785cad1fbd7de03 *Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh" | md5sum -c - && \
    /bin/bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -f -b -p $CONDA_DIR && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    #echo "conda ${CONDA_VERSION}" >> $CONDA_DIR/conda-meta/pinned && \
    $CONDA_DIR/bin/conda config --system --prepend channels conda-forge && \
    $CONDA_DIR/bin/conda config --system --set auto_update_conda false && \
    $CONDA_DIR/bin/conda config --system --set show_channel_urls true && \
    $CONDA_DIR/bin/conda install --quiet --yes conda && \
    $CONDA_DIR/bin/conda update --all --quiet --yes && \
    $CONDA_DIR/bin/conda list python | grep '^python ' | tr -s ' ' | cut -d '.' -f 1,2 | sed 's/$/.*/' >> $CONDA_DIR/conda-meta/pinned && \
    $CONDA_DIR/bin/conda clean --all -f -y
ENV PATH=/opt/conda/bin:$PATH

# Install Tini
RUN conda install --quiet --yes 'tini' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y

# Install Jupyter Notebook, Lab, and Hub
# Generate a notebook server config
# Cleanup temporary files
# Correct permissions
# Do all this in a single RUN command to avoid duplicating all of the
# files across image layers when the permissions change
RUN conda install --quiet --yes \
    'jupytext' \
    'sqlalchemy' \
    'tornado' \
    'jinja2' \
    'traitlets' \
    'requests' \
    'pycurl' \
    'notebook' \
    'jupyterhub' \
    'jupyterlab' && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging

RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000

LABEL org.jupyter.service="jupyterhub"

RUN apt-get update && apt-get -yq dist-upgrade \
 && apt-get install -yq --no-install-recommends \
    ipython \
    python-ipykernel \
    python-ipython && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN jupyter nbextension install --py jupytext && \
    jupyter nbextension enable --py jupytext && \
    jupyter lab build && \
    jupyter labextension install jupyterlab-jupytext && \
    python2 -m ipykernel install --name python2

## Integrate jupiter/docker-stacks/minimal-notebook
RUN apt-get update && apt-get install -yq --no-install-recommends \
    build-essential \
    emacs \
    inkscape \
    jed \
    libsm6 \
    libxext-dev \
    libxrender1 \
    lmodern \
    netcat \
    pandoc \
    python-dev \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex \
    tzdata \
    nano \
    && rm -rf /var/lib/apt/lists/*

## Integrate jupiter/docker-stacks/r-notebook
# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gcc && \
    rm -rf /var/lib/apt/lists/*

# Fix for devtools https://github.com/conda-forge/r-devtools-feedstock/issues/4
RUN ln -s /bin/tar /bin/gtar

# R packages
RUN conda install --quiet --yes \
    'r-base=3.5.1' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-plyr' \
    'r-randomforest' \
    'r-rcurl' \
    'r-reshape2' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-sparklyr' \
    'r-tidyverse' \
    'unixodbc' \
    && \
    conda clean --all -f -y

# Install e1071 R package (dependency of the caret R package)
RUN conda install --quiet --yes r-e1071 && \
    conda clean --all -f -y

## Integrate jupiter/docker-stacks/spicy-notebook
# ffmpeg for matplotlib anim
RUN apt-get update && \
    apt-get install -y --no-install-recommends ffmpeg && \
    rm -rf /var/lib/apt/lists/*

# Install Python 3 packages
RUN conda install --quiet --yes \
    'beautifulsoup4' \
    'conda-forge::blas=*=openblas' \
    'bokeh' \
    'cloudpickle' \
    'cython' \
    'dask' \
    'dill' \
    'h5py' \
    'hdf5' \
    'ipywidgets' \
    'matplotlib-base' \
    'numba' \
    'numexpr' \
    'pandas' \
    'patsy' \
    'protobuf' \
    'scikit-image' \
    'scikit-learn' \
    'scipy' \
    'seaborn' \
    'sqlalchemy' \
    'statsmodels' \
    'sympy' \
    'vincent' \
    'xlrd' \
    && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    jupyter labextension install jupyterlab_bokeh --no-build && \
    jupyter lab build --dev-build=False && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging

# Install facets which does not have a pip or conda package at the moment
RUN cd /tmp && \
    git clone https://github.com/PAIR-code/facets.git && \
    cd facets && \
    jupyter nbextension install facets-dist/ --sys-prefix && \
    cd && \
    rm -rf /tmp/facets

# Import matplotlib the first time to build the font cache.
#ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

# Install machinelearning from rocker/tensorflow
RUN conda install --quiet --yes \
    'tensorflow' \
    'keras' && \
    conda clean --all -f -y

## Install older iRKernel
# Install R 3.4.3 and some base packages
RUN conda create -n r-3.4.3 \
    'r-base=3.4.3' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-plyr' \
    'r-randomforest' \
    'r-rcurl' \
    'r-reshape2' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-sparklyr' \
    'r-tidyverse' \
    'unixodbc' \
	'r-e1071' \
    && \
    conda clean --all -f -y

# Install R 3.3.2 and some base packages
RUN conda create -n r-3.3.2 \
    'r-base=3.3.2' \
    'r-caret' \
    'r-crayon' \
    'r-devtools' \
    'r-forecast' \
    'r-hexbin' \
    'r-htmltools' \
    'r-htmlwidgets' \
    'r-irkernel' \
    'r-nycflights13' \
    'r-plyr' \
    'r-randomforest' \
    'r-rcurl' \
    'r-reshape2' \
    'r-rmarkdown' \
    'r-rodbc' \
    'r-rsqlite' \
    'r-shiny' \
    'r-sparklyr' \
    'r-tidyverse' \
    'unixodbc' \
	'r-e1071' \
    && \
    conda clean --all -f -y

RUN /usr/local/bin/Rscript -e "install.packages('IRkernel', repos='http://cran.us.r-project.org')"
RUN ln -s /opt/conda/bin/jupyter /usr/local/bin/
RUN /usr/local/bin/R -e "IRkernel::installspec(user = FALSE, name = 'ir361', displayname = 'R 3.6.1')"
RUN conda init bash
RUN /opt/conda/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir351', displayname = 'R 3.5.1')"
RUN /opt/conda/envs/r-3.4.3/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir343', displayname = 'R 3.4.3')"
RUN /opt/conda/envs/r-3.3.2/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir332', displayname = 'R 3.3.2')"
RUN ln -s /opt/conda/bin/pip /usr/local/bin/pip3

## Mods for our environment
# Change auth.py to allow CammelCase
COPY mods/auth.py /opt/conda/lib/python3.7/site-packages/jupyterhub/auth.py
# Add further Paths
COPY mods/spawner.py /opt/conda/lib/python3.7/site-packages/jupyterhub/spawner.py
# Override kernel files
COPY mods/kernel.json-3.5.1 /opt/conda/share/jupyter/kernels/ir/kernel.json
COPY mods/Renviron-3.5.1 /opt/conda/lib/R/etc/Renviron
COPY mods/kernel.json-3.6.1 /usr/local/share/jupyter/kernels/ir353/kernel.json
COPY mods/Renviron-3.6.1 /usr/local/lib/R/etc/Renviron
COPY mods/kernel.json-3.4.3 /usr/local/share/jupyter/kernels/ir343/kernel.json
COPY mods/kernel.json-3.3.2 /usr/local/share/jupyter/kernels/ir332/kernel.json

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyterhub", "-f /etc/jupyterhub/jupyterhub_config.py"]
