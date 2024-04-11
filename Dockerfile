ARG OPENRESTY_VERSION="1.25.3.1-2"
FROM openresty/openresty:${OPENRESTY_VERSION}-alpine-fat

ARG APP_NAME="openresty-playground"
ARG APP_VERSION="1.0-0"

# Environment variables.
ENV \
    OPENRESTY_VERSION=${OPENRESTY_VERSION} \
    APP_NAME=${APP_NAME} \
    APP_VERSION=${APP_VERSION} \
    APP_ROCKSPEC_NAME="${APP_NAME}-${APP_VERSION}" \
    ENABLE_HEALTHCHECK="false"

WORKDIR /opt

# Install Alpine Linux package essential packages.
RUN \
    apk update && \
    apk add --no-cache \
        bash \
        git \
        yaml-dev \
        openssl \
        nss-tools \
        go \
        inotify-tools \
        imagemagick \
        imagemagick-dev

# Copy and set execute permissions for entrypoint and monitoring scripts.
COPY docker/scripts/entrypoint.sh entrypoint.sh
RUN chmod +x entrypoint.sh

COPY docker/scripts/monitor.sh /usr/local/bin/monitor.sh
RUN chmod +x /usr/local/bin/monitor.sh

RUN mkdir -p ${APP_ROCKSPEC_NAME}

# Creating a dummy archive to be able to install the rockspec dependencies.
# https://github.com/luarocks/luarocks/wiki/Rockspec-format
RUN tar -czvf ${APP_ROCKSPEC_NAME}.tar.gz ./
COPY docker/${APP_ROCKSPEC_NAME}.rockspec ./

# Install the Lua dependencies specified in the rockspec file.
RUN luarocks install \
    ${APP_ROCKSPEC_NAME}.rockspec

# Clean up unnecessary packages and temporary files to minimize the Docker image size.
RUN \
    apk del \
    git \
    nss-tools \
    go

RUN \
    rm -rf ${APP_ROCKSPEC_NAME}* \
    /var/cache/luarocks/* \
    /var/cache/apk/* \
    /tmp/* \
    /var/log/*

# Docker healthcheck configuration.
HEALTHCHECK \
    --interval=30s \
    --timeout=10s \
    --start-period=1m \
    --retries=3 \
    CMD if [ "$ENABLE_HEALTHCHECK" = "true" ]; then curl --fail http://localhost:8000/health || exit 1; else exit 0; fi

EXPOSE 8080

# Set the container's entrypoint to `/opt/entrypoint.sh`.
ENTRYPOINT ["/opt/entrypoint.sh"]

# Start Nginx in the foreground.
CMD ["nginx", "-g", "daemon off;"]
