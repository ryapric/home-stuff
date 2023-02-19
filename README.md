# Home stuff

This repo has the tooling needed to set up various home automation, networking,
etc. facilities for the stuff I want for my home. The primary intent is for
these services to be hosted externally, but is subject to change based on the
nature of the services themselves or hardware in my home.

## Who is this for?

Me. That's it. If you see something you don't like, or don't think should be
done in a certain way, don't @ me.

## How to use

1. Within the `infra/` subdir, stand up infrastructure via a standard Terraform
   workflow.

1. From within the `infra/` subdir, run `provision.sh` to upload the
   configuration code for the machine.

1. From within the `infra/` subdir, run `make ssh` to connect to the remote
   machine manually.
