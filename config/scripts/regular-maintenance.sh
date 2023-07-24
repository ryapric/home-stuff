#!/usr/bin/env bash
set -euo pipefail

cd /home/admin/home-stuff/config || exit 1

# Tear down Docker Compose stack completely, and restart. Note that we're
# backing up resolv.conf because otherwise DNS will go down once Pi-hole does
mv /etc/resolv.conf{,.bak}
printf 'nameserver 9.9.9.9\n' > /etc/resolv.conf
# TODO: once the stack has more than just Pi-hole in it, maybe be a bit less
# nuclear here
docker compose down
docker system prune --force
docker volume ls --format '{{ .Name }}' | grep pihole | xargs -I{} docker volume rm {}
docker compose up -d --wait
mv /etc/resolv.conf{.bak,}
docker exec pihole sh -c 'pihole -g'
