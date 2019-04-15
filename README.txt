Devops Engineer Test
==================


Recommended Requirements:

Latest versions of the following:
Vagrant, virtualbox, vagrant-vbgust plugin

Usage
======
clone this repo
In this dir run: vagrant up

From the guest-vm (using vagrant ssh)
curl http://127.0.0.1:80/dog
curl http://127.0.0.1:80/cat
curl http://127.0.0.1:80/goat

Testing for 404:
curl http://127.0.0.1:80/fish
curl http://127.0.0.1:80/elephant

From your host machine the port has been mapped to 8000, so you can use the following from a web
browser:
http://127.0.0.1:8000/cat etc...

Strategy
========
Using a setup script to setup the machine, environment, application beyond the initial vagant
provinisioning. (setup.sh)

This is installs the required ubuntu debs using apt-get, builds the applications, and then starts
them.  Starting the applications only happens after all builds have completed successfully - the
script has a "set -e" to ensure it terminates on the first command which exists with a none-zero
exit code.

The dog application uses a docker compose yml file, and not a standard dockerFile.  This is as it is
made up of 2 containers.  One for the nginx and the other for the php app itself.  The nginx
component could have been merged with the main nginx config, but I wanted the main one to be
standard amongst all apps, and only contain a single proxy pass to each of the applications.  Any
application-specific config should not be in the main nginx config.

Security
========
The dog application is set up to only accept a URI which is /show.  This means that we will be using
a path as a script, which by default returns an error.  This is because fpm has a setting
(security.limit_extension) which ensures that you can not arbitrarily execute scripts, which may have been maliciously placed on the server.  To my knowledge there are two ways around this.  The first is to configure fpm to allow this, and the other is to modify the source to only check if /show is within the path.  We can then pass a filename to the application (in this case index.php).  This is rewritten in the app's nginx so that we still supply the same url as the other 2 applications and it is transparent to the user, and to the main nginx instance.  I chose the latter method.

TODO
====
At the moment, the building/starting of the applications is only done at provisioning time.  This
means if the host is restarted, the applications will not be restarted.  However, as they are
already built, they can simply be started using docker run.  This can be maintained using docker's restart policy.

Testing - this is probably best with an automated selenium system running in headless mode.  It will ensure that given paths are always available and return the correct http code, with the correct content after changes.
