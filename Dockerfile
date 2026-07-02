FROM alpine:3.24

# Install dependencies
RUN apk add --no-cache \
    mariadb-client \
    postgresql-client \
    gzip pigz \
    bzip2 \
    xz \
    lzip \
    zstd \
    gpg gpg-agent \
    minio-client \
    mongodb-tools

