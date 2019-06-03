#!/usr/bin/env bash

sudo systemctl stop privatebin.service
sudo systemctl stop nginx-proxy.service
sudo systemctl stop nginx-proxy-letsencrypt.service
