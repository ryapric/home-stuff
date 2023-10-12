#!/usr/bin/env bash
set -euo pipefail

export platform="${1:-}"
if [[ -z "${platform}" ]] ; then
  printf '>>> ERROR: platform name (vagrant|aws|any) not provided as script arg\n' > /dev/stderr
  exit 1
fi

if [[ "${platform}" == 'vagrant' ]] ; then
  export user='vagrant'
  printf 'vagrant\nvagrant\n' | passwd vagrant
else
  export user='admin'
fi

# Put files in the right place, and fix perms in case provisions got messy
cp -r /tmp/home-stuff /home/"${user}"/home-stuff
chown -R "${user}":"${user}" /home/"${user}"

printf '>>> Installing system utilities...\n'
apt-get update && apt-get full-upgrade -y
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  git \
  golang \
  gnupg2 \
  htop \
  lsb-release \
  make \
  net-tools \
  nmap \
  rlwrap \
  rsync \
  socat \
  tree \
  unzip \
  zip \
  zsh

# src_root is where the equivalent root dir of the source repo lives on the
# host, and cfg_dir is its config subdir
export src_root="/home/${user}/home-stuff"
export cfg_dir="${src_root}/config"

printf '>>> Setting up ZShell...\n'
[[ -d /tmp/oh-my-zsh ]] || git -C /tmp clone https://github.com/ohmyzsh/ohmyzsh.git oh-my-zsh
sudo -u "${user}" bash -c "[[ -d /home/${user}/.oh-my-zsh ]] || bash /tmp/oh-my-zsh/tools/install.sh --unattended"
[[ "${SHELL}" == "$(command -v zsh)" ]] || sudo chsh -s "$(command -v zsh)" "${user}"

printf '>>> Installing Docker...\n'
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/docker.gpg
printf 'deb https://download.docker.com/linux/debian %s stable\n' "$(lsb_release -cs)" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose-plugin
usermod -aG docker "${user}"

printf '>>> Bringing up services defined in docker-compose.yaml...\n'
cmpfile="${cfg_dir}/docker-compose.yaml"
docker compose -f "${cmpfile}" pull
docker compose -f "${cmpfile}" up -d --wait
docker system prune --volumes --force

printf '>>> Installing cockpit...\n'
apt-get install -y cockpit

printf '>>> Setting up systemd services...\n'

cat <<EOF > /etc/systemd/system/regular-maintenance.service
[Unit]
Description=Periodic maintenance tasks for home-stuff services
Wants=regular-maintenance.timer

[Service]
ExecStart=${cfg_dir}/scripts/regular-maintenance.sh
Type=oneshot

[Install]
WantedBy=multi-user.target
EOF

cat <<EOF > /etc/systemd/system/regular-maintenance.timer
[Unit]
Description=Daily maintenance tasks for home-stuff services

[Timer]
Unit=regular-maintenance.service
OnBootSec=30s
OnCalendar=Sun *-*-* 04:*:*
AccuracySec=1s
Persistent=true

[Install]
WantedBy=timers.target
EOF

systemctl daemon-reload
systemctl enable regular-maintenance.timer
systemctl start regular-maintenance.timer

# TODO: if you want to add adlists URLs, you can manually insert relevant
# records into the gravity DB one at a time, like so (in v5+):
#     docker exec pihole sqlite3 /etc/pihole/gravity.db "INSERT INTO adlist (address, enabled, comment) VALUES ('${adlist_url}', 1, '${adlist_comment}');"
# which you can run in a loop where you 'docker exec' each one you want. You'll
# also then need to update gravity once they're all added:
#     docker exec pihole pihole -g

apt-get autoclean
apt-get autoremove -y

printf '>>> All done!\n'
