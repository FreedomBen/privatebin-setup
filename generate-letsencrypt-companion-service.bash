#!/usr/bin/env bash

IMAGE_NAME=jrcs/letsencrypt-nginx-proxy-companion
CONTAINER_NAME=nginx-proxy-letsencrypt

SERVICE_FILE_DEST='nginx-proxy-letsencrypt.service'

die ()
{
  echo "[DIE]: $1"
  exit 1
}

read -r -d '' DOCKER_RUN <<EOF
$(which docker) run --rm 
  --volumes-from nginx-proxy
  --volume '/var/run/docker.sock:/var/run/docker.sock:ro'
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

echo "$SERVICE_CONTENTS" > ${SERVICE_FILE_DEST}
