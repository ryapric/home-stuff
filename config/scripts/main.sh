#!/usr/bin/env bash
set -euo pipefail

export platform="${1:-}"
if [[ -z "${platform}" ]] ; then
  printf 'ERROR: platform name (vagrant|aws) not provided as script arg\n' > /dev/stderr
  exit 1
fi

if [[ "${platform}" == 'vagrant' ]] ; then
  export user='vagrant'
  cp -r /vagrant/* /home/vagrant/
else
  export user='admin'
fi

chown -R "${user}":"${user}" /home/"${user}"

cd /home/"${user}" || exit 1

printf 'Installing system utilities...\n'
apt-get update && apt-get full-upgrade -y
apt-get install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  git \
  gnupg2 \
  htop \
  lsb-release \
  make \
  net-tools \
  nmap \
  unzip \
  zip

printf 'Installing Docker...\n'
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor > /etc/apt/trusted.gpg.d/docker.gpg
printf "deb https://download.docker.com/linux/debian %s stable\n" "$(lsb_release -cs)" > /etc/apt/sources.list.d/docker.list
apt-get update
apt-get install -y \
  docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-compose-plugin
usermod -aG docker "${user}"

printf 'Bringing up services defined in docker-compose.yaml...\n'
docker compose -f /home/"${user}"/config/docker-compose.yaml up -d --wait

printf 'All done!\n'
