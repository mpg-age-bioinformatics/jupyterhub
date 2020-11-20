# Try to generate seperate layers
# Use hub.age.mpg.de/rstudio:3.6.1 as baseimage as we want to use the same R version on both interfaces 
ARG BASE_CONTAINER=mpgagebioinformatics/jupyter-age:2.0.0
FROM $BASE_CONTAINER
LABEL maintainer="Daniel Rosskopp <drosskopp@upcal.de>"

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
COPY mods/Renviron-4.0.3 /usr/local/lib/R/etc/Renviron
COPY mods/Rprofile.site /opt/conda/envs/r-4.0.3/lib/R/etc/Rprofile.site
RUN ln -s /usr/local/lib/R/bin/R /bin/R-4.0.3
RUN ln -s /usr/local/lib/R/bin/Rscript /bin/Rscript-4.0.3

# COPY mods/etc/jupyter_notebook_config.py /etc/jupyter/jupyter_notebook_config.py

# Configure container startup
ENTRYPOINT ["tini", "-g", "--"]
CMD ["jupyterhub", "-f /etc/jupyterhub/jupyterhub_config.py"]
