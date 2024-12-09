#!/usr/bin/env bash
set -euo pipefail

if [[ -z "${1:-}" ]] ; then
  printf 'ERROR: you must supply a host as the first script arg. Exiting.\n' > /dev/stderr
  exit 1
fi
host="${1}"

ansible_flags="--inventory ${host},"
if [[ "${host}" == 'localhost' || "${host}" == '127.0.0.1' ]] ; then
  ansible_flags="${ansible_flags} --connection local"
fi

apt-get update && apt-get install -y \
  ansible-core \
  ansible-lint \
  make \
  sudo

src="$(dirname "$(dirname "${BASH_SOURCE[0]}")")"
ansible-galaxy install -r "${src}/ansible/requirements.yaml"
ansible-lint "${src}/ansible/main.yaml"
# The next line doesn't quote the flags var because it intentionally needs to be
# multiple tokens
# shellcheck disable=SC2086
ansible-playbook ${ansible_flags} "${src}/ansible/main.yaml"
