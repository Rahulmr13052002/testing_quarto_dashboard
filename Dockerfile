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

# ---- Install additional R packages ----
RUN R -e "install.packages(c( \
    'DBI','RMariaDB','pool','reactable','bslib','bsicons','DT','scales','htmltools' \
), repos='https://cloud.r-project.org')"

# ---- Set working directory and copy app ----
WORKDIR /app
COPY . /app

# ---- Expose port for Render ----
EXPOSE 10000

# ---- Start Quarto Preview ----
CMD ["quarto", "preview", "index.qmd", "--host", "0.0.0.0", "--port", "10000", "--no-browser"]
