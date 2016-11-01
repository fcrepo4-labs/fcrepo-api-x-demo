# Summary
Provides Docker images and orchestration for various Fedora API-X components.

Individual READMEs linked below contain example usage for common docker tasks, like obtaining a command shell in a container or setting the container up for remote debugging.  The [docker-compose](docker-compose.yaml) file is intended to orchestrate these containers using a single command.

# Requirements

See [this page](https://docs.docker.com/engine/getstarted/step_one/) for more information on getting started with Docker for your platform.

* [Docker for Mac](https://download.docker.com/mac/stable/Docker.dmg), or
* [Docker for Windows](https://download.docker.com/win/stable/InstallDocker.msi), or
* [Docker Toolbox for Mac](https://www.docker.com/products/docker-toolbox), or
* [Docker for Linux](https://docs.docker.com/engine/installation/)

To verify you have the Docker platform installed correctly (or to check and see if you have Docker already installed), you should obtain a command shell and run:

1. `docker -v`
2. `docker-compose -v`

If either of these commands fail to print out version information, then you'll need to troubleshoot your installation before moving forward.

# Getting Started

To bring up this environment, you need to:

1. Install Docker and verify the installation (above)
2. Clone this repository
3. `cd` into the repository directory
4. Invoke `docker-compose up -d`

Depending on the speed of your platform, it may take a bit for the containers to download and to start.  Keep that in mind when you are verifying that the environment started up.  The containers should only be downloaded once.  Subsequent invocation of `docker-compose` should be faster, since the images will not need to be downloaded.

*Note:* To _destroy_ the environment, run `docker-compose down`.  To _stop_ the environment, run `docker-compose stop`.  

## Verification

Note that if you are using Docker Toolbox for Mac, you will need to find the IP address of your Docker Machine (try `docker-machine ls`), and use that IP address anywhere you see `localhost` in the following instructions.  

* Visit http://localhost:8080/fcrepo/rest and see the Fedora REST API web page
* Visit http://localhost:9102/jsonld/ and see a JSON LD representation of the root Fedora container.
* `curl -i http://localhost/fcrepo/rest` and see a response from API-X

Once you can verify that the environment is up and working, move on to some of the sample [API-X exercises](apix-exercises.md).

# Image descriptions

This repository provides Dockerfiles for the following images:

## [build](build/)
A base image, built from Ubuntu 16.04 (for various reasons, but mainly because Karaf 4.0.6+ requires glibc, and cannot use musl), containing a Java 8 build environment with Maven.

## [fcrepo 4.6.0](fcrepo/4.6.0)
Extends the base image, and provides a default-configured Fedora 4.6.0 runtime on port 8080.  Debugging the runtime is possible by supplying an environment variable named "DEBUG".

## [karaf 4.0.6](karaf/4.0.6)
Extends the base image, and provides a Karaf container running version 4.0.6.  Debugging the runtime is possible by supplying `debug` as an argument to `docker run`.

## [acrepo](acrepo/LATEST)
Extends the _karaf_ image, and provides a Karaf container with the Amherst features already installed and running.
