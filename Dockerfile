# Builder: render the Quarto site using the official Quarto image
FROM quay.io/quarto-dev/quarto:latest AS builder
WORKDIR /src
COPY . /src

# Render the site. If the project produces a `_site` folder it will be used;
# otherwise we collect generated HTML and supporting files into `/out`.
RUN quarto render --no-cache || true
RUN mkdir -p /out \
  && if [ -d _site ]; then cp -r _site/* /out/ ; else cp -r ./*.html ./index_files ./auth /out/ || true; fi

# Final image: serve with nginx
FROM nginx:stable-alpine
LABEL org.opencontainers.image.description="Quarto site (rendered) served by nginx"
COPY --from=builder /out/ /usr/share/nginx/html/

EXPOSE 80

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD wget -qO- --spider http://localhost:80 || exit 1

CMD ["nginx", "-g", "daemon off;"]
