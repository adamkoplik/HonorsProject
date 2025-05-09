    # Pulling Rocker image with RStudio and R version 4.2
FROM rocker/rstudio:4.4


# Setting environment variables
ARG CONDA_ENV=flex_dashboard
ENV CONDA_ENV=$CONDA_ENV

ARG PYTHON_VER=3.8
ENV PYTHON_VER=$PYTHON_VER

ARG QUARTO_VERSION=1.7.27
ENV QUARTO_VERSION=$QUARTO_VERSION

# Disabling the authentication step
ENV USER="rstudio"
CMD ["/usr/lib/rstudio-server/bin/rserver", "--server-daemonize", "0", "--auth-none", "1"]

# Install jq to parse json files
RUN apt-get update && apt-get install -y --no-install-recommends \
    jq \
    libxml2-dev \
    zlib1g \
    g++-11 \
    libz-dev \
    freetype2-demos \
    libpng-dev \
    libtiff-dev \
    libjpeg-dev \
    make \
    fontconfig \
    libfribidi-dev \
    libharfbuzz-dev \
    libfontconfig1-dev \
    git \
    vim \
    && rm -rf /var/lib/apt/lists/*

# installing R packages
RUN mkdir packages
COPY install_packages.R packages/
COPY install_python.R packages/
COPY packages.json packages/
RUN Rscript packages/install_packages.R

# Installing Quarto
COPY install_quarto.sh packages/
RUN  bash packages/install_quarto.sh $QUARTO_VERSION


# Install miniconda
RUN sudo apt update && apt-get install -y --no-install-recommends \
    software-properties-common \
    && sudo add-apt-repository -y ppa:deadsnakes/ppa \
    && sudo apt update 

ARG ARCH
RUN ARCH=$(uname -m) && \
    if [ "$ARCH" = "aarch64" ]; then \
        URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh; \
    else \
        URL=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh; \
    fi && \
    wget --quiet $URL -O ~/miniconda.sh && \
    bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    export PATH="/opt/conda/bin:$PATH" && \
    conda init bash && \
    conda install -y conda-build

# Set environment
RUN . /root/.bashrc \
    && conda create -y --name $CONDA_ENV python=$PYTHON_VER 

RUN echo "conda activate $CONDA_ENV" >> ~/.bashrc
RUN Rscript packages/install_python.R

RUN apt-get update && apt-get install -y libcurl4-openssl-dev

# Add Rprofile with VScode settings

EXPOSE 8787