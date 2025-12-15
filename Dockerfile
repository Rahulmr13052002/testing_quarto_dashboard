# ---- Base image ----
FROM rocker/verse:4.3.2

# ---- System dependencies ----
RUN apt-get update && apt-get install -y \
    libmariadb-dev \
    wget \
    pandoc \
    && rm -rf /var/lib/apt/lists/*

# ---- Install Quarto CLI ----
RUN wget -q https://github.com/quarto-dev/quarto-cli/releases/download/v1.5.55/quarto-1.5.55-linux-amd64.deb \
    && dpkg -i quarto-1.5.55-linux-amd64.deb \
    && rm quarto-1.5.55-linux-amd64.deb

# ---- Install ALL required R packages ----
RUN R -e "install.packages(c( \
    'plotly', \
    'reactable', \
    'bslib', \
    'bsicons', \
    'DBI', \
    'RMariaDB', \
    'pool', \
    'DT', \
    'scales', \
    'htmltools' \
), repos='https://cloud.r-project.org')"

# ---- App directory ----
WORKDIR /app
COPY . /app

# ---- Expose Render port ----
EXPOSE 10000

# ---- Start Quarto Preview ----
CMD ["quarto", "preview", "index.qmd", "--host", "0.0.0.0", "--port", "10000", "--no-browser"]
