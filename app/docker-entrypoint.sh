#!/bin/bash
set -e

DOCKER_USER='dockeruser'
DOCKER_GROUP='dockergroup'

if ! id "$DOCKER_USER" >/dev/null 2>&1; then
    echo "First start of the docker container, start initialization process."

    USER_ID=${PUID:-9001}
    GROUP_ID=${PGID:-9001}
    echo "Starting with $USER_ID:$GROUP_ID (UID:GID)"

    if ! getent group $DOCKER_GROUP >/dev/null; then
        if ! getent group $GROUP_ID >/dev/null; then
            addgroup -g $GROUP_ID $DOCKER_GROUP
        else
            DOCKER_GROUP=$(getent group $GROUP_ID | cut -d: -f1)
        fi
    fi

    adduser -D -s /bin/sh -u $USER_ID -G $DOCKER_GROUP $DOCKER_USER

    chown -vR $USER_ID:$GROUP_ID $APP_PATH
    chmod -vR ug+rwx $APP_PATH
    chown -vR $USER_ID:$GROUP_ID $DATA_PATH
fi

export HOME=/home/$DOCKER_USER
exec su-exec $DOCKER_USER $APP_PATH/app.sh
