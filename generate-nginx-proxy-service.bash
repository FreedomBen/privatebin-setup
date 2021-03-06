#!/usr/bin/env bash

IMAGE_NAME=jwilder/nginx-proxy
CONTAINER_NAME=nginx-proxy

SERVICE_FILE_DEST='nginx-proxy.service'

die ()
{
  echo "[DIE]: $1"
  exit 1
}

read -r -d '' DOCKER_RUN <<EOF
$(which docker) run --rm 
  --publish 80:80
  --publish 443:443
  --volume 'nginx-certs:/etc/nginx/certs'
  --volume 'nginx-vhost:/etc/nginx/vhost.d'
  --volume 'nginx-html:/usr/share/nginx/html'
  --volume '/var/run/docker.sock:/tmp/docker.sock:ro'
  --name $CONTAINER_NAME $IMAGE_NAME
EOF
# get rid of line breaks
DOCKER_RUN=$(echo $DOCKER_RUN)

read -d '' SERVICE_CONTENTS <<EOF
[Unit]
Description=NginxProxy
Requires=privatebin.service
After=privatebin.service

[Service]
Restart=always
ExecStart=$DOCKER_RUN
ExecStop=$(which docker) stop -t 2 $CONTAINER_NAME

[Install]
WantedBy=local.target
EOF

echo "$SERVICE_CONTENTS" > ${SERVICE_FILE_DEST}
