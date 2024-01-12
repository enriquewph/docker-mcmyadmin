FROM eclipse-temurin:21-jre-alpine

ENV \
  APP_PATH="/app" \
  DATA_PATH="/data" \
  MC_PWD=pass123

# Map installation to external volume so the user can configure
VOLUME ${DATA_PATH}

# Create install path and change dir
WORKDIR ${DATA_PATH}

# Install required packages
RUN apk update && \
    apk add --no-cache dumb-init procps curl unzip git eudev libgdiplus screen su-exec fontconfig && \
    rm -rf /var/cache/apk/*

# download and unpack McMyAdmin
RUN \
  curl -o /tmp/MCMA2_glibc26_2.zip -L http://mcmyadmin.com/Downloads/MCMA2_glibc26_2.zip && \
  curl -o /tmp/etc.zip -L http://mcmyadmin.com/Downloads/etc.zip && \
  unzip /tmp/etc.zip -d /usr/local && \
  mkdir -vp $APP_PATH/config && \
  unzip /tmp/MCMA2_glibc26_2.zip -d $APP_PATH/config && \
  chmod -v a+rx $APP_PATH/config/MCMA2_Linux_x86_64 && \
  rm -rf /tmp/* \
  rm -rf $APP_PATH/config/McMyAdmin.exe $APP_PATH/config/MCMA_Service.exe 

# Copy local files to image
COPY app/ /app/

# Install glibc compatibility for Alpine Linux (Following https://stackoverflow.com/a/66974607 with some modifications)
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.30-r0

RUN set -ex && \
    apk --update add libstdc++ curl ca-certificates && \
    for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
        do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
    apk add --allow-untrusted --force-overwrite /tmp/*.apk && \
    rm -v /tmp/*.apk && \
    /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

# allow read and execution of the script
RUN chmod -v a+rx $APP_PATH/*.sh

# Expose required ports
EXPOSE 8080 25565

# Start up
ENTRYPOINT ["/usr/bin/dumb-init", "--"]
CMD ["/app/docker-entrypoint.sh"]