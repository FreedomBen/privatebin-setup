#!/usr/bin/env bash

IMAGE_NAME=privatebin/nginx-fpm-alpine:1.2.1
CONTAINER_NAME=privatebin
DNS_NAME=privatebin.example.com
LETSENCRYPT_EMAIL=freedomben@example.com
PORT_NUM=54323 # TODO don't expose any ports to host

#SYSD_DIR='/etc/systemd/system'
SYSD_DIR='./'
SERVICE_FILE_DEST='privatebin.service'

die ()
{
  echo "[DIE]: $1"
  exit 1
}

read -r -d '' DOCKER_RUN <<EOF
$(which docker) run --rm -p ${PORT_NUM}:80
  --env 'VIRTUAL_HOST=${DNS_NAME}'
  --env 'LETSENCRYPT_HOST=${DNS_NAME}'
  --env 'LETSENCRYPT_EMAIL=${LETSENCRYPT_EMAIL}'
  --volume 'privatebin-data:/srv/data'
  --name $CONTAINER_NAME $IMAGE_NAME
EOF
# get rid of line breaks
DOCKER_RUN=$(echo $DOCKER_RUN)

read -d '' SERVICE_CONTENTS <<EOF
[Unit]
Description=PrivateBin
Requires=docker.service
After=docker.service

[Service]
Restart=always
ExecStart=$DOCKER_RUN
ExecStop=$(which docker) stop -t 2 $CONTAINER_NAME

[Install]
WantedBy=local.target
EOF

mkdir -p "$SYSD_DIR"
[ -d "$SYSD_DIR" ] || die "systemd directory $SYSD_DIR does not exist!"

echo "$SERVICE_CONTENTS" > ${SYSD_DIR}/${SERVICE_FILE_DEST}
