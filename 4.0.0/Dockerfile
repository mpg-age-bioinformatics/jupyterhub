FROM continuumio/miniconda3:4.12.0

LABEL maintainer="bioinformatics@age.mpg.de"
LABEL org.jupyter.service="jupyterhub"

RUN apt-get update \
 && apt-get install -yq --no-install-recommends \
	bzip2 \
	fonts-liberation \
    locales && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set env for installing miniconda
ENV CONDA_DIR=/opt/conda \
    SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

RUN echo "en_US.UTF-8 UTF-8" > /etc/locale.gen && \
    locale-gen

RUN apt-get update && apt-get install -y --no-install-recommends \
    libpam-sss \
    libnss-sss \
    libnss3 \
    libgsl-dev \
    gsl-bin \
    netcdf-bin \
    libnetcdf-dev \
    h5utils \
    hdf-compass \
    hdf5-helpers \
    hdf5-tools \
    libhdf5-java \
    libhdf5-doc \
    libhdf5-dev \
    libhdf5-cpp-103 \
    libhdf5-jni \
    libhdf5-mpi-dev \
    libhdf5-mpich-103 \
    libhdf5-mpich-dev \
    libhdf5-openmpi-103 \
    libhdf5-openmpi-dev \
#    libjhdf5-java \
#    libjhdf5-jni \
    java-common \
    libasound2 \
    libcairo-gobject2 \
    libgtk-3-0 \
    libxtst6 \
    libnode-dev \
    libxml2 \
    libmagick++-6-headers \
    libmagick++-dev \
    imagemagick \
    libxml2-dev \
    libcairo2-dev \
    libsqlite3-dev \
    libmariadbd-dev \
    libmariadb-dev-compat \
    libpq-dev \
    libicu-dev \
    libbz2-dev \
    liblzma-dev \
    libssh-dev \
    libicu-dev \
    libbz2-dev \
    liblzma-dev \
    autotools-dev \
    gettext \
    gettext-base \
    groff-base \
    libgdbm6 \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    liblapack-dev \
    libncurses5-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtinfo-dev \
    zlib1g-dev \
    liblapack-dev \
    libgdal-dev \
    libgdal28 \
    libgtk2.0-0 \
    libgtk2.0-common && \
  apt-get autoremove -y && \
  apt-get autoclean -y && \
  rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    apt-get -yq dist-upgrade && \
    apt-get install -yq pkg-config \
    libcairo2-dev \
    python3 \
    python3-pip \
    texlive \
    texlive-latex-extra \
    texlive-xetex \
    texlive-fonts-recommended \
    texlive-plain-generic \
    pandoc && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN conda update --all --quiet --yes

RUN conda install --quiet --yes \
    'sqlalchemy' \
    'tornado' \
    'jinja2' \
    'traitlets' \
    'requests' \
    'pycurl' \
    'notebook' \
    'jupyterhub' \
    'jupyterlab' \
    'pyxdg==0.26' && \
    conda install -c conda-forge jupytext nodejs && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging
# 'jupytext' && 'voila'\

# Install Tini
RUN conda install -c conda-forge --quiet --yes 'tini' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y

RUN apt-get update && apt-get -yq dist-upgrade  && \
    apt-get install -yq --no-install-recommends \
    locales \
    apt-utils \
    ipython3 \
    python3-ipykernel \
    python3-ipython && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 ; localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; exit 0

# locale-gen en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && 

RUN jupyter nbextension install --py jupytext && \
    jupyter nbextension enable --py jupytext && \
    jupyter lab build && \
    jupyter labextension install jupyterlab-jupytext && \
    python3 -m ipykernel install --name python3

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
    tzdata \
    nano \
    texlive-fonts-extra \
    libc-bin \
    texlive-fonts-recommended \
    texlive-base \
    texlive-latex-base \
    texlive-latex-extra \
    texlive-xetex && \
    rm -rf /var/lib/apt/lists/*

## Integrate jupiter/docker-stacks/r-notebook
# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    unixodbc \
    unixodbc-dev \
    r-cran-rodbc \
    gfortran \
    gcc && \
    rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes \
    'beautifulsoup4' \
#    'conda-forge::blas=*=openblas' \
    'openblas' \
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
#    'seaborn' \
    'sqlalchemy' \
    'statsmodels' \
    'sympy' \
#    'vincent' \
    'xlrd' \
    'tensorflow' \
    'openpyxl' \
    'keras' && \
    conda clean --all -f -y && \
    # Activate ipywidgets extension in the environment that runs the notebook server
    jupyter nbextension enable --py widgetsnbextension --sys-prefix && \
    # Also activate ipywidgets extension for JupyterLab
    # Check this URL for most recent compatibilities
    # https://github.com/jupyter-widgets/ipywidgets/tree/master/packages/jupyterlab-manager
    jupyter labextension install @jupyter-widgets/jupyterlab-manager --no-build && \
    #jupyter labextension install jupyterlab_bokeh --no-build && \
    jupyter lab build --dev-build=False && \
    jupyter labextension install jupyterlab-plotly && \
    npm cache clean --force && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging

# Import matplotlib the first time to build the font cache.
#ENV XDG_CACHE_HOME /home/$NB_USER/.cache/
RUN MPLBACKEND=Agg python -c "import matplotlib.pyplot"

RUN mkdir -p /srv/jupyterhub/
WORKDIR /srv/jupyterhub/
EXPOSE 8000
RUN ln -s /opt/conda/bin/jupyter /usr/local/bin/
RUN ln -s /opt/conda/bin/pip /usr/local/bin/pip3

# Install R 3.6.3 and some base packages
RUN conda create -c conda-forge -n r-3.6.3 \
    'r-base=3.6.3' \
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

RUN /opt/conda/envs/r-3.6.3/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir363', displayname = 'R 3.6.3')"
RUN conda init bash

COPY mods/kernel.json-3.6.3 /usr/local/share/jupyter/kernels/ir363/kernel.json
COPY mods/Renviron-3.6.3 /opt/conda/envs/r-3.6.3/lib/R/etc/Renviron
COPY mods/Rprofile.site /opt/conda/envs/r-3.6.3/lib/R/etc/Rprofile.site
RUN ln -s /opt/conda/envs/r-3.6.3/bin/R /bin/R-3.6.3
RUN ln -s /opt/conda/envs/r-3.6.3/bin/Rscript /bin/Rscript-3.6.3


# Install R 4.0.3 and some base packages
RUN conda create -c conda-forge -n r-4.0.3 \
    'r-base=4.0.3' \
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

RUN /opt/conda/envs/r-4.0.3/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir403', displayname = 'R 4.0.3')"
RUN conda init bash

COPY mods/kernel.json-4.0.3 /usr/local/share/jupyter/kernels/ir403/kernel.json
COPY mods/Renviron-4.0.3 /opt/conda/envs/r-4.0.3/lib/R/etc/Renviron
COPY mods/Rprofile.site /opt/conda/envs/r-4.0.3/lib/R/etc/Rprofile.site
RUN ln -s /opt/conda/envs/r-4.0.3/bin/R /bin/R-4.0.3
RUN ln -s /opt/conda/envs/r-4.0.3/bin/Rscript /bin/Rscript-4.0.3

# Install R 4.1.3 and some base packages
RUN conda create -c conda-forge -n r-4.1.3 \
    'r-base=4.1.3' \
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

RUN /opt/conda/envs/r-4.1.3/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir413', displayname = 'R 4.1.3')"
RUN conda init bash

COPY mods/kernel.json-4.1.3 /usr/local/share/jupyter/kernels/ir413/kernel.json
COPY mods/Renviron-4.1.3 /opt/conda/envs/r-4.1.3/lib/R/etc/Renviron
#COPY mods/Rprofile.site /opt/conda/envs/r-4.1.3/lib/R/etc/Rprofile.site
RUN ln -s /opt/conda/envs/r-4.1.3/bin/R /bin/R-4.1.3
RUN ln -s /opt/conda/envs/r-4.1.3/bin/Rscript /bin/Rscript-4.1.3

# Install R 4.2.1 and some base packages
RUN conda create -c conda-forge -n r-4.2.1 \
    'r-base=4.2.1' \
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

RUN /opt/conda/envs/r-4.2.1/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir421', displayname = 'R 4.2.1')"
RUN conda init bash

COPY mods/kernel.json-4.2.1 /usr/local/share/jupyter/kernels/ir421/kernel.json
COPY mods/Renviron-4.2.1 /opt/conda/envs/r-4.2.1/lib/R/etc/Renviron
#COPY mods/Rprofile.site /opt/conda/envs/r-4.2.1/lib/R/etc/Rprofile.site
RUN ln -s /opt/conda/envs/r-4.2.1/bin/R /bin/R-4.2.1
RUN ln -s /opt/conda/envs/r-4.2.1/bin/Rscript /bin/Rscript-4.2.1

RUN conda install -c conda-forge -n r-4.0.3 'r-rjava'
RUN conda install -c conda-forge -n r-4.1.3 'r-rjava'
RUN conda install -c conda-forge -n r-4.2.1 'r-rjava'

RUN echo "JAVA_HOME=/opt/conda/envs/r-4.0.3" >>  /opt/conda/envs/r-4.0.3/lib/R/etc/Renviron && \
    echo "JAVA_LD_LIBRARY_PATH=/opt/conda/envs/r-4.0.3/jre/lib/amd64/server" >>  /opt/conda/envs/r-4.0.3/lib/R/etc/Renviron
RUN echo "JAVA_HOME=/opt/conda/envs/r-4.1.3" >>  /opt/conda/envs/r-4.1.3/lib/R/etc/Renviron && \
    echo "JAVA_LD_LIBRARY_PATH=/opt/conda/envs/r-4.1.3/jre/lib/amd64/server" >>  /opt/conda/envs/r-4.1.3/lib/R/etc/Renviron
RUN echo "JAVA_HOME=/opt/conda/envs/r-4.2.1" >>  /opt/conda/envs/r-4.2.1/lib/R/etc/Renviron && \
    echo "JAVA_LD_LIBRARY_PATH=/opt/conda/envs/r-4.2.1/jre/lib/amd64/server" >>  /opt/conda/envs/r-4.2.1/lib/R/etc/Renviron

## Mods for our environment
# Change auth.py to allow CammelCase
COPY mods/auth.py /opt/conda/lib/python3.7/site-packages/jupyterhub/auth.py
# Add further Paths
COPY mods/spawner.py /opt/conda/lib/python3.7/site-packages/jupyterhub/spawner.py
# jupyter_notebook_config.py
COPY mods/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

RUN mkdir -p /opt/conda/pkgs/ && touch /opt/conda/pkgs/urls.txt
RUN apt-get update && apt install -yq libgirepository1.0-dev acl && apt-get clean && rm -rf /var/lib/apt/lists/*
RUN conda install -c bioconda bedtools

# RUN rm -rf /usr/local/share/jupyter/kernels/ir351

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyterhub", "-f /etc/jupyterhub/jupyterhub_config.py"]

