# Summary
This repository provides Docker images and orchestration for various Fedora API-X components in support of [demonstrating and evaluating](exercises/README.md) API-X in action.  

# Requirements

Before proceeding with the [evaluation tasks](exercises/README.md) in this for API-X you will need to download, install, and verify required software.  It does not make sense to proceed with the evaluation until these prerequisites are satisfied.

## Docker
See [this page](https://docs.docker.com/engine/getstarted/step_one/) for more information on getting started with Docker for your platform.  These four flavors of docker largely behave the same, as far as instructions for the demo are concerned:

* [Docker for Mac](https://download.docker.com/mac/stable/Docker.dmg), or
* [Docker for Windows](https://download.docker.com/win/stable/InstallDocker.msi), or
* [Docker for Linux](https://docs.docker.com/engine/installation/), or
* [Docker Toolbox for Mac/Windows](https://www.docker.com/products/docker-toolbox) (a/k/a _docker-machine_)

"Docker for Mac" and "Docker for Windows" place significant requirements on the mimimum required OS version and features.

In contrast, the legacy flavor of Docker (which we'll refer to as _docker-machine_) runs Docker inside Virtualbox, and can be run on almost any OS.  Unfortunately, the evaluation instructions differ slightly for _docker-machine_.   
* You need to start an instance of _docker-machine_ to run the docker containers.  See the [create a machine](https://docs.docker.com/machine/get-started/) documentation for how to do that.

After installing *one* of the four variants of Docker above (or to simply check and see if you have Docker already installed), verify you have the Docker platform installed correctly. Obtain a command shell and run:

    docker -v
    docker-compose -v

If either of these commands fail to print out version information, then you'll need to troubleshoot your installation before moving forward.  A recent version of Docker should suffice, but if you have trouble running the milestone with older versions of Docker, please let us know, and upgrade to the latest version before trying the milestone again.

## curl
curl is available for [many platforms](https://curl.haxx.se/download.html), and is included by default some operating systems.  To determine if you have curl installed, obtain a command shell and run:

    curl --version

If no version information is printed, then you'll need to download and install curl, or otherwise troubleshoot your installation.  Any semi-modern version of curl ought to suffice.

# Getting Started

To bring up the API-X environment, you need to:

1. Install Docker and verify the installation (above)
2. Retrieve the `docker-compose.yaml` file for this demo.  There are two ways to do this:
  * Clone this git repository:  `git clone https://github.com/fcrepo4-labs/fcrepo-api-x-demo.git`.  This will create a directory `fcrepo-api-x-demo` with the required file(s) in it
  * [Directly download it](https://raw.githubusercontent.com/fcrepo4-labs/fcrepo-api-x-demo/master/docker-compose.yaml) by following the preceeding link.
3. `cd` into the directory containing the docker-compose file
4. If you directly downloaded the `docker-compose.yaml` file (i.e. did not clone from github) create a file in the current directory called apix.env
  <pre>
  touch apix.env
  </pre>
5. **_docker-machine_ users only:** set the `APIX_HOST` and `APIX_BASEURI` environment variable.  *Substitute the name of your docker machine for the `default` machine if necessary*:
    * `docker-machine ip default` (ensure the output is an IP address, and not an error message)
    * <code>echo "APIX_HOST=&#x60;docker-machine ip default&#x60;" > apix.env</code>
    * <code>echo "APIX_BASEURI=http://&#x60;docker-machine ip default&#x60;/fcrepo/rest" >> apix.env</code>
    * Here's an example `apix.env` file using a docker machine with IP of 192.168.99.100
    <pre>
    APIX_HOST=192.168.99.100
    APIX_BASEURI=http://192.168.99.100/fcrepo/rest
    </pre>
5. Invoke `docker-compose up -d`

Depending on the speed of your platform, it may take a bit for the containers to download and to start.  Keep that in mind when you are verifying that the environment started up.  The containers should only be downloaded once.  Subsequent invocation of `docker-compose` should be faster, since the images will not need to be downloaded.

*Note:* To _destroy_ the environment, run `docker-compose down`; this will stop all services _and remove all data_, such that the next time you start the environment, it will be starting up from scratch.  To _stop_ the environment, run `docker-compose stop`; this will shut down the environment, but keep the data so that you can resume where you left off.  Use `docker-compose up -d` to start or re-start the environment.

## Verification

_**docker-machine users only** You will need to find the IP address of your Docker Machine (try `docker-machine ip default`), and use that IP address anywhere you see `localhost` in the following instructions._

* Visit `http://localhost:8080/fcrepo/rest` and see the Fedora REST API web page
* Visit `http://localhost:9102/jsonld/` to directly invole an Amherst service and see a JSON LD representation of the root Fedora container.
* Visit `http://localhost/fcrepo/rest` and see a a Fedora resource as exposed by API-X

Once you can verify that the environment is up and working, move on to some of the sample [API-X exercises](exercises/README.md).

# Image descriptions

This repository provides Dockerfiles for the following images that will be run in containers orchestrated by docker-compose:

* [acrepo](acrepo/LATEST) -  Provides a Karaf container with [repository services provided by Amherst College](https://gitlab.amherst.edu/acdc/repository-extension-services/) already installed and running.
* [apix](apix/0.1.0) - Provides a Karaf container with API-X installed and configured in a useful way for the demo.
* [fcrepo](fcrepo/4.7.0) - Provides a default-configured Fedora 4.7.0.
* [fuseki](fuseki/2.3.1) - Provides a triplestore index of API-X service documents
* [indexing](indexing/0.1.0) - Ancillary (i.e. not considered "core") API-X image that keeps the demonstration triplestore up-to-date
