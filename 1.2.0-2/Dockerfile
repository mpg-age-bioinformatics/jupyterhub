# Try to generate seperate layers
# Use hub.age.mpg.de/rstudio:3.6.1 as baseimage as we want to use the same R version on both interfaces 
ARG BASE_CONTAINER=kumpelfilzchen/jupyter:1.2.0
FROM $BASE_CONTAINER
LABEL maintainer="Daniel Rosskopp <drosskopp@upcal.de>"

# RUN apt-get update && apt-get install -yq vim 

# Install R 3.4.3 and some base packages
RUN conda create -n r-4.0.3 \
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

# old ones

COPY mods/Rprofile.site /opt/conda/envs/r-3.4.3/lib/R/etc/Rprofile.site
COPY mods/Renviron-3.4.3 /opt/conda/envs/r-3.4.3/lib/R/etc/Renviron
COPY mods/Rprofile.site /opt/conda/lib/R/etc/Rprofile.site
COPY mods/Rprofile.site /usr/local/lib/R/etc/Rprofile.site

# COPY mods/etc/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyterhub", "-f /etc/jupyterhub/jupyterhub_config.py"]
