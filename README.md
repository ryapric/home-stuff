# Home stuff

This repo has the tooling needed to set up various home automation, networking, etc. facilities for
the stuff I want for my home. The primary intent is for these services to be hosted internally, but
is subject to change based on the nature of the services themselves or hardware in my home.

This is all expected to be running on a Debian server, and supporting code is
written accordingly.

## Who is this for?

Me. That's it. If you see something you don't like, or don't think should be done in a certain way,
don't @ me.

## How to use

* If infra is on the local network:

  1. Run `make run host=<target_host_ip>`. That should do it.

* If infra is remote:

  1. TODO: revisit this some day, home infra is pretty good at the time of this writing and I have
     mostly not touched the Terraform code in here in years.
