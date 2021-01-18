FROM mpgagebioinformatics/jupyter-age:3.0.0

RUN conda install -c conda-forge -n r-4.0.3 'r-rjava'

RUN echo "JAVA_HOME=/opt/conda/envs/r-4.0.3" >>  /opt/conda/envs/r-4.0.3/lib/R/etc/Renviron && \
    echo "JAVA_LD_LIBRARY_PATH=/opt/conda/envs/r-4.0.3/jre/lib/amd64/server" >>  /opt/conda/envs/r-4.0.3/lib/R/etc/Renviron
