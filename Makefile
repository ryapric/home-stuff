provision:
	@bash ./config/scripts/provision.sh

test-local:
	@vagrant up

test-local-stop:
	@vagrant destroy -f
