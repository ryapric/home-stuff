#!/usr/bin/env bash
set -euo pipefail

# NOTE: commented-out code below is from before the Ansible refactor; keeping it
# for easier revisiting later if needed

# cd /home/admin/home-stuff/config || exit 1

# # Tear down Docker Compose stack completely, and restart. Note that we're
# # backing up resolv.conf because otherwise DNS will go down once Pi-hole does
# # and wew won't be able to e.g. pull image updates during that downtime
# mv /etc/resolv.conf{,.bak}
# printf 'nameserver 9.9.9.9\n' > /etc/resolv.conf
# # TODO: once the stack has more than just Pi-hole in it, maybe be a bit less
# # nuclear here
# docker compose down
# docker system prune --force
# docker volume ls --format '{{ .Name }}' | grep pihole | xargs -I{} docker volume rm {}
# docker compose up -d --wait
# mv /etc/resolv.conf{.bak,}

bash /home/admin/home-stuff/config/scripts/main.sh localhost
docker exec pihole sh -c 'pihole -g'
