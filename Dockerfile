FROM alpine:3.24

# Install dependencies
RUN apk add --no-cache \
    mariadb-client \
    postgresql18-client \
    gzip pigz \
    bzip2 \
    xz \
    lzip \
    zstd \
    gpg gpg-agent \
    minio-client \
    mongodb-tools \
    kubectl
