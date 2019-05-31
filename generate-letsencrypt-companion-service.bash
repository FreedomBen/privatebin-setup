#!/usr/bin/env bash

IMAGE_NAME=jrcs/letsencrypt-nginx-proxy-companion
CONTAINER_NAME=nginx-proxy-letsencrypt

#SYSD_DIR='/etc/systemd/system'
SYSD_DIR='./'
SERVICE_FILE_DEST='nginx-proxy-letsencrypt.service'

die ()
{
  echo "[DIE]: $1"
  exit 1
}

read -r -d '' DOCKER_RUN <<EOF
$(which docker) run --rm 
  --volumes-from nginx-proxy
  --volume 'nginx-vhost:/etc/nginx/vhost.d'
  --volume 'nginx-html:/etc/nginx/html'
  --volume '/var/run/docker.sock:/tmp/docker.sock:ro'
  --name $CONTAINER_NAME $IMAGE_NAME
EOF
# get rid of line breaks
DOCKER_RUN=$(echo $DOCKER_RUN)

read -d '' SERVICE_CONTENTS <<EOF
[Unit]
Description=NginxProxyLetsencryptCompanion
Requires=nginx-proxy.service
After=nginx-proxy.service

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
