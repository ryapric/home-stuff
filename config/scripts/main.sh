#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]] ; then
  printf 'ERROR: you must supply a host as the first script arg. Exiting.\n' > /dev/stderr
  exit 1
fi

host="${1:-localhost}"
ansible_flags="--inventory ${host},"
if [[ "${host}" == 'localhost' ]] ; then
  ansible_flags="${ansible_flags} --connection local"
fi

apt-get update && apt-get install -y \
  ansible-core \
  ansible-lint \
  make \
  sudo

ansible-galaxy role install \
  geerlingguy.docker

src="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
ansible-lint "${src}/ansible/main.yaml"
# The next line doesn't quote the flags var because it intentionally needs to be
# multiple tokens
# shellcheck disable=SC2086
ansible-playbook ${ansible_flags} "${src}/ansible/main.yaml"

# printf '>>> Bringing up services defined in docker-compose.yaml...\n'
# cmpfile="${cfg_dir}/docker-compose.yaml"
# docker compose -f "${cmpfile}" pull
# docker compose -f "${cmpfile}" up -d --wait
# docker system prune --volumes --force

# printf '>>> Setting up systemd services...\n'

# cat <<EOF > /etc/systemd/system/regular-maintenance.service
# [Unit]
# Description=Periodic maintenance tasks for home-stuff services
# Wants=regular-maintenance.timer

# [Service]
# ExecStart=${cfg_dir}/scripts/regular-maintenance.sh
# Type=oneshot

# [Install]
# WantedBy=multi-user.target
# EOF

# cat <<EOF > /etc/systemd/system/regular-maintenance.timer
# [Unit]
# Description=Daily maintenance tasks for home-stuff services

# [Timer]
# Unit=regular-maintenance.service
# OnBootSec=30s
# OnCalendar=Sun *-*-* 04:*:*
# AccuracySec=1s
# Persistent=true

# [Install]
# WantedBy=timers.target
# EOF

# systemctl daemon-reload
# systemctl enable regular-maintenance.timer
# systemctl start regular-maintenance.timer

# # TODO: if you want to add adlists URLs, you can manually insert relevant
# # records into the gravity DB one at a time, like so (in v5+):
# #     docker exec pihole sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (address, enabled, comment) VALUES ('${adlist_url}', 1, '${adlist_comment}');"
# # which you can run in a loop where you 'docker exec' each one you want. You'll
# # also then need to update gravity once they're all added:
# #     docker exec pihole pihole -g

# printf '>>> All done!\n'
