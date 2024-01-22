FROM alpine:3.19

# Install dependencies
RUN apk add --no-cache \
    mariadb-client \
    postgresql-client \
    gzip pigz \
    bzip2 \
    xz \
    lzip plzip \
    zstd \
    gpg \
    minio-client

