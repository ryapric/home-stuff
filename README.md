# Home stuff

This repo has the tooling needed to set up various home automation, networking,
etc. facilities for the stuff I want for my home. The primary intent is for
these services to be hosted externally, but is subject to change based on the
nature of the services themselves or hardware in my home.

This is all expected to be running on a Debian server, and supporting code is
written accordingly.

## Who is this for?

Me. That's it. If you see something you don't like, or don't think should be
done in a certain way, don't @ me.

## How to use

* If infra is remote:

  1. Within the `infra/` subdir, stand up infrastructure via a standard
     Terraform workflow.

  1. Run `make provision` to upload & run the configuration code for the server.

  1. If needed, run `make -C infra ssh` to connect to the remote machine
     manually.

* If infra is on the local network:

  1. Set the `HOMESTUFF_IP` variable to whatever the local IP of your server
     is.

  1. Run `make provision` to upload & run the configuration code for the server.

  1. If needed, ssh to the remote machine manually (via
     `admin@${HOMESTUFF_IP}`).
