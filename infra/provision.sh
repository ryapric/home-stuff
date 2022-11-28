#!/usr/bin/env bash
set -euo pipefail

host="admin@$(terraform output -raw static_ip)"

printf 'Uploading files to server...\n'
scp \
  -o StrictHostKeyChecking=false \
  -r \
  ../config \
  "${host}":/home/admin/

printf 'Running main config script...\n'
ssh "${host}" -- sudo bash /home/admin/config/scripts/main.sh aws
