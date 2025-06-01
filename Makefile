SHELL := /usr/bin/env bash -euo pipefail

run:
	@bash ./config/scripts/main.sh $(host)

test-local:
	@vagrant up --no-provision
	@vagrant provision

test-local-stop:
	@vagrant destroy -f
