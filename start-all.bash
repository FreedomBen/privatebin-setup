#!/usr/bin/env bash

sudo systemctl start privatebin.service
sudo systemctl start nginx-proxy.service
sudo systemctl start nginx-proxy-letsencrypt.service
