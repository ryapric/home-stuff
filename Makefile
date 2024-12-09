SHELL := /usr/bin/env bash -euo pipefail

provision:
	@bash ./config/scripts/provision.sh

test-local:
	@vagrant up --no-provision
	@vagrant provision

test-local-stop:
	@vagrant destroy -f
