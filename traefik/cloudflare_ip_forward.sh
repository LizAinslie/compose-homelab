#!/bin/bash

# a package yq (https://github.com/mikefarah/yq) is required for operation
# you can install it with the command:
#
#       wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/bin/yq && chmod +x /usr/bin/yq
#

# for example, here is the path to traefik in the dokploy (https://github.com/Dokploy/dokploy) instance
CONFIG_FILE_PATH=${1:-./traefik.yml}
BACKUP_FILE_PATH=${2:-./traefik.yml.bak}

cat $CONFIG_FILE_PATH > $BACKUP_FILE_PATH;

yq -i "del(.entryPoints.websecure.forwardedHeaders.trustedIPs)" $CONFIG_FILE_PATH;
yq -i "del(.entryPoints.web.forwardedHeaders.trustedIPs)" $CONFIG_FILE_PATH;
yq -i "del(.entryPoints.smtp.forwardedHeaders.trustedIPs)" $CONFIG_FILE_PATH;
yq -i "del(.entryPoints.smtps.forwardedHeaders.trustedIPs)" $CONFIG_FILE_PATH;
yq -i "del(.entryPoints.imaps.forwardedHeaders.trustedIPs)" $CONFIG_FILE_PATH;

for i in `curl -s -L https://www.cloudflare.com/ips-v4`; do
    yq -i ".entryPoints.websecure.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.web.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.smtp.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.smtps.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.imaps.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;

done

for i in `curl -s -L https://www.cloudflare.com/ips-v6`; do
    yq -i ".entryPoints.websecure.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.web.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.smtp.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.smtps.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
    yq -i ".entryPoints.imaps.forwardedHeaders.trustedIPs += [\"$i\"]" $CONFIG_FILE_PATH;
done
