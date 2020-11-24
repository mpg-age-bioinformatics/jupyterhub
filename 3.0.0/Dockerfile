FROM continuumio/miniconda3:4.8.2

LABEL maintainer="bioinformatics@age.mpg.de"
LABEL org.jupyter.service="jupyterhub"


# Set env for installing miniconda
ENV CONDA_DIR=/opt/conda \
	SHELL=/bin/bash \
    LC_ALL=en_US.UTF-8 \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US.UTF-8

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
    'jupyterlab' && \
    conda install -c conda-forge jupytext nodejs==14.15.1 && \
    conda clean --all -f -y && \
    npm cache clean --force && \
    jupyter notebook --generate-config && \
    rm -rf $CONDA_DIR/share/jupyter/lab/staging
# 'jupytext' && 'voila'\

# Install Tini
RUN conda install --quiet --yes 'tini' && \
    conda list tini | grep tini | tr -s ' ' | cut -d ' ' -f 1,2 >> $CONDA_DIR/conda-meta/pinned && \
    conda clean --all -f -y

RUN apt-get update && apt-get -yq dist-upgrade  && \
    apt-get install -yq --no-install-recommends \
    locales \
    apt-utils \
    ipython \
    python-ipykernel \
    python-ipython && \
    apt-get purge && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN localedef -v -c -i en_US -f UTF-8 en_US.UTF-8 ; localedef -v -c -i en_US -f UTF-8 en_US.UTF-8; exit 0

# locale-gen en_US.UTF-8 && export LC_ALL=en_US.UTF-8 && 

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
    tzdata \
    nano \
    texlive-fonts-extra \
    libc-bin \
    texlive-fonts-recommended \
    texlive-generic-recommended \
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
    gcc && \
    rm -rf /var/lib/apt/lists/*

RUN conda install --quiet --yes \
    'beautifulsoup4' \
    'conda-forge::blas=*=openblas' \
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

RUN /opt/conda/envs/r-3.4.3/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir343', displayname = 'R 3.4.3')"
RUN conda init bash

COPY mods/kernel.json-3.4.3 /usr/local/share/jupyter/kernels/ir343/kernel.json
COPY mods/Renviron-3.4.3 /opt/conda/envs/r-3.4.3/lib/R/etc/Renviron
COPY mods/Rprofile.site /opt/conda/envs/r-3.4.3/lib/R/etc/Rprofile.site
RUN ln -s /opt/conda/envs/r-3.4.3/bin/R /bin/R-3.4.3
RUN ln -s /opt/conda/envs/r-3.4.3/bin/Rscript /bin/Rscript-3.4.3


# Install R 3.5.1 and some base packages
RUN conda create -n r-3.5.1 \
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
	'r-e1071' \
    && \
    conda clean --all -f -y

RUN /opt/conda/envs/r-3.5.1/bin/Rscript -e "IRkernel::installspec(user = FALSE, name = 'ir351', displayname = 'R 3.5.1')"
RUN conda init bash

COPY mods/kernel.json-3.5.1 /usr/local/share/jupyter/kernels/ir351/kernel.json
COPY mods/Renviron-3.5.1 /opt/conda/envs/r-3.5.1/lib/R/etc/Renviron
COPY mods/Rprofile.site /opt/conda/envs/r-3.5.1/lib/R/etc/Rprofile.site
RUN ln -s /opt/conda/envs/r-3.5.1/bin/R /bin/R-3.5.1
RUN ln -s /opt/conda/envs/r-3.5.1/bin/Rscript /bin/Rscript-3.5.1


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

COPY mods/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

## Mods for our environment
# Change auth.py to allow CammelCase
# COPY mods/auth.py /opt/conda/lib/python3.7/site-packages/jupyterhub/auth.py
# Add further Paths
# COPY mods/spawner.py /opt/conda/lib/python3.7/site-packages/jupyterhub/spawner.py


# RUN rm -rf /usr/local/share/jupyter/kernels/ir351

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyterhub", "-f /etc/jupyterhub/jupyterhub_config.py"]


