# Infracode

This subdir controls infrastructure deployment, and provides a configuration
wrapper, `provision.sh`.

You will first need a Terraform backend config vars file. Then you can run the
init via:

    terraform init -backend-config=backend.tfvars

Post-init, you can run your standard plan-apply-destroy workflow as needed.

Once the infrastructure is up, you can run `provision.sh` to grab the server's
public IP address, copy some files from `../config/`, and run the main
configuration script (`../config/scripts/main.sh`) on the remote host.

## NOTE

The infracode is currently set to allow traffic ***only from the deployer
IP address***, which is probably your house. This does make the server itself
more secure, but it also means you can't do anything to fix issues when not
making requests from that IP. If your home IP ever gets cycled, you'll also need
to redeploy!
