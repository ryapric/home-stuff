#!/usr/bin/env bash
set -euo pipefail

local_root="$(git rev-parse --show-toplevel)"

if [[ -n "${HOMESTUFF_IP:-}" ]] ; then
  platform="any"
  host="admin@${HOMESTUFF_IP:-NOT_SET}"
else
  platform="aws"
  host="admin@$(terraform -chdir="${local_root}"/infra output -raw static_ip)"
fi

printf 'Uploading files to server...\n'
scp \
  -o StrictHostKeyChecking=false \
  -r \
  "${local_root}" \
  "${host}":/tmp/home-stuff

printf 'Running main config script...\n'
ssh "${host}" -- sudo bash /tmp/home-stuff/config/scripts/main.sh "${platform}"
