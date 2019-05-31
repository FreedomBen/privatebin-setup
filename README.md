# PrivateBin setup scripts

This repo can be used to install a private bin setup onto a server

## Pre-requisites

You need an internet facing VPS with:

1.  systemd
1.  docker
1.  DNS setup and configured

## Installing

1.  _*Important:*_ Set the `DNS_NAME` and `LETSENCRYPT_EMAIL` variables appropriately in `generate-privatebin-service.bash`
1.  Run each of the "generate..." scripts.  There are three.
1.  Copy the generated \*.service files into the appropriate systemd directory (usually /etc/systemd/system)
1.  Start the new services:
  1.  systemctl start privatebin
  1.  systemctl start nginx-proxy
  1.  systemctl start nginx-proxy-letsencrypt
1.  Profit!
