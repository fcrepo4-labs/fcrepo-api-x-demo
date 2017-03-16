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

1. Install Docker and verify the installation (above).  You will need a version of docker-compose greater than or equal to 1.7.1 (this only concerns folks who may have an older version of docker-compose already installed).
2. Retrieve the `docker-compose.yaml` and `.env` file for this demo.  There are two ways to do this:
  * Clone this git repository:  `git clone https://github.com/fcrepo4-labs/fcrepo-api-x-demo.git`.  This will create a directory `fcrepo-api-x-demo` with the required file(s) in it
  * Directly download [docker-compose.yaml](https://raw.githubusercontent.com/fcrepo4-labs/fcrepo-api-x-demo/master/docker-compose.yaml) and [.env](https://raw.githubusercontent.com/fcrepo4-labs/fcrepo-api-x-demo/master/.env)
3. `cd` into the directory containing the docker-compose file
4. **_docker-machine_ users only:** edit the `.env` file, and set the `APIX_BASEURI` environment variable.  *Substitute the name of your docker machine for the `default` machine if necessary*:
    * `docker-machine ip default` (obtains the IP address of your *default* docker-machine)
    * Here's an example `.env` file using a docker machine with IP of 192.168.99.100
    <pre>
    ...
    APIX_PORT=80
    APIX_BASEURI=http://192.168.99.100/fcrepo/rest
    ...
    </pre>
    * Double-check your changes to the `.env` file, being aware of any potential typos!!
5. Invoke `docker-compose up -d`

Depending on the speed of your platform, it may take a bit for the images to download and to start (images should only be downloaded once).  Subsequent invocation of `docker-compose` should be faster, since the images will not need to be downloaded.

*Note:* To _destroy_ the environment, run `docker-compose down`; this will stop all services _and remove all data_, such that the next time you start the environment, it will be starting up from scratch.  To _stop_ the environment, run `docker-compose stop`; this will shut down the environment, but keep the data so that you can resume where you left off.  Use `docker-compose up -d` to start or re-start the environment.

## [Using alternate ports](#alternate-ports)
By default, this demo will publish several services, binding to a number of ports on your computer in the process.  For example, the API-X proxy will bind to port `80`, the Fedora repository to port `8080`, and the Fuseki triplestore to port `3030`.

The default ports are:
* 80 - API-X
* 3030 - Fuseki (triple store)
* 8080 - Fedora
* 8081 - API-X Loader Service
* 9102-9107 - Various Amherst services   

Users may experience port conflicts with non-API-X services that are already running on their computer.  If shutting down the conflicting services is not an option, it will be necessary to map the API-X-related services to alternate ports.  This can be done by editing the environment file, `.env` (see the default file, which gives you an idea of the ports the demo will use,  [here](https://raw.githubusercontent.com/fcrepo4-labs/fcrepo-api-x-demo/master/.env)).  

For example, to publish the API-X proxy on port `8000` instead of the default port `80`, modify `APIX_PORT=80` to read `APIX_PORT=8000`, and modify `APIX_BASEURI` to read `APIX_BASEURI=http://localhost:8000/fcrepo/rest`.

If you wish to move the Fedora repository from port `8080` to port `10000`, modify:
* `FCREPO_PORT` to read `FCREPO_PORT=10000`
* `FCREPO_BASEURI` to read `FCREPO_BASEURI=http://fcrepo:10000/fcrepo/rest`
* `FCREPO_PROXYURI` to read `FCREPO_PROXYURI=http://fcrepo:8080/fcrepo`

**Note:** After saving your changes to `.env`, you will need to destroy and re-build the containers, performing a `docker-compose down` followed by `docker-compose up -d`.  Double-check your changes to the `.env` file, being aware of any potential typos!!

## Verification
*!!! The instructions below use the **default** URLs and ports found in the environment file (`.env`)*  
*!!! If you have modified the environment file, you must be sure to substitute the correct URL and port in the instructions below.*

* Visit `http://localhost:8080/fcrepo/rest` and see the Fedora REST API web page
* Visit `http://localhost:9102/jsonld/` to directly invoke an Amherst service and see a JSON LD representation of the root Fedora container.
* Visit `http://localhost/fcrepo/rest` and see a Fedora resource as exposed by API-X

Once you can verify that the environment is up and working, move on to some of the sample [API-X exercises](exercises/README.md).

# Image descriptions
This repository provides Dockerfiles for the following images that will be run in containers orchestrated by docker-compose:

* [acrepo](acrepo/LATEST) -  Provides a Karaf container with [repository services provided by Amherst College](https://gitlab.amherst.edu/acdc/repository-extension-services/) already installed and running.
* [apix](apix/0.2.0) - Provides a Karaf container with API-X installed and configured in a useful way for the demo.
* [fcrepo](fcrepo/4.7.1-tomcat) - Provides a default-configured Fedora 4.7.1.
* [fuseki](fuseki/2.4.1) - Provides a triplestore index of API-X service documents and repository objects
* [indexing](indexing/0.2.0) - Ancillary (i.e. not considered "core") API-X image that keeps the demonstration triplestores up-to-date
