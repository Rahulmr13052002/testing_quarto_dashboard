# ---- Base image ----
FROM rocker/r-ver:4.3.2

# ---- System dependencies ----
RUN apt-get update && apt-get install -y \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    libmariadb-dev \
    pandoc \
    wget \
    && rm -rf /var/lib/apt/lists/*

# ---- Install Quarto ----
RUN wget -q https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.55/quarto-1.5.55-linux-amd64.deb \
    && dpkg -i quarto-1.5.55-linux-amd64.deb \
    && rm quarto-1.5.55-linux-amd64.deb

# ---- Install R packages at build time ----
RUN R -e "install.packages(c( \
    'tidyverse','plotly','reactable','bslib','bsicons', \
    'DBI','RMariaDB','pool','scales','DT','htmltools' \
), repos='https://cloud.r-project.org')"

# ---- Set app directory ----
WORKDIR /app
COPY . /app

# ---- Expose port ----
EXPOSE 10000

# ---- Start Quarto Dashboard Server ----
CMD ["quarto", "serve", "index.qmd", "--host", "0.0.0.0", "--port", "10000"]
