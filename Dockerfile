# ---- Base image ----
FROM rocker/shiny:4.3.2

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

# ---- R packages ----
RUN R -e "install.packages(c( \
    'tidyverse','plotly','reactable','bslib','bsicons', \
    'shiny','DBI','RMariaDB','pool','scales','DT','htmltools','pacman' \
), repos='https://cloud.r-project.org')"

# ---- App directory ----
WORKDIR /app
COPY . /app

# ---- Expose Render port ----
EXPOSE 10000

# ---- Start Quarto Shiny dashboard ----
CMD ["quarto", "serve", "index.qmd", "--host", "0.0.0.0", "--port", "10000"]
