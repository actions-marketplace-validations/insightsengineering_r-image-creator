# Build arguments
ARG BASE_IMAGE="rocker/rstudio:4.3.0"

# Fetch base image
FROM $BASE_IMAGE

# Build arguments
ARG SYSDEPS=""
ARG RENV_LOCK=""
ARG OTHER_PKG=""
ARG REPOS=""

# Set image metadata
LABEL org.opencontainers.image.licenses="GPL-2.0-or-later" \
    org.opencontainers.image.source="https://github.com/insightsengineering/r-image-creator" \
    org.opencontainers.image.vendor="Insights Engineering" \
    org.opencontainers.image.authors="Insights Engineering <insightsengineering@example.com>"

# Set working directory
WORKDIR /workspace

# Copy installation scripts
COPY --chmod=0755 ./scripts /scripts

# Copy of RENV_LOCK (conditionnal because this might be also a direct URL)
COPY ./renv.lock /workspace

# Install remote 
RUN R -e 'install.packages(c("remotes"), repos="https://cloud.r-project.org/")'

# Install renv from GitHub.
ENV RENV_VERSION=0.17.0  
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

# Install all script
RUN /scripts/install_all.sh ${SYSDEPS} ${RENV_LOCK} ${OTHER_PKG} ${REPOS} 

# delete scripts folder
RUN rm -rf /scripts

# Run RStudio
CMD ["/init"]
