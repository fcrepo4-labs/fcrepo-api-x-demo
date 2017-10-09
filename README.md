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
4. **_docker-machine_ users only:** edit the `.env` file, and set the `PUBLIC_REPOSITORY_HOST` and `PUBLIC_REPOSITORY_BASEURI` environment variables.  *Substitute the name of your docker machine for the `default` machine if necessary*:
    * `docker-machine ip default` (obtains the IP address of your *default* docker-machine)
    * Here's an example `.env` file using a docker machine with IP of 192.168.99.100
    <pre>
    ...
    PUBLIC\_REPOSITORY\_PORT=80
    PUBLIC\_REPOSITORY\_HOST=192.168.99.100
    PUBLIC\_REPOSITORY\_BASEURI=http://192.168.99.100/fcrepo/rest
    ...
    </pre>
    * Double-check your changes to the `.env` file, being aware of any potential typos!!
5. Pull in the latest images via `docker-compose pull`
6. Invoke `docker-compose up -d` to start all images.

Depending on the speed of your platform, it may take a bit for the images to download and to start (images should only be downloaded once).  Subsequent invocation of `docker-compose` should be faster, since the images will not need to be downloaded.

*Note:* To _destroy_ the environment, run `docker-compose down`; this will stop all services _and remove all data_, such that the next time you start the environment, it will be starting up from scratch.  To _stop_ the environment, run `docker-compose stop`; this will shut down the environment, but keep the data so that you can resume where you left off.  Use `docker-compose up -d` to start or re-start the environment.

*Note:* it is usually a good idea to run `docker-compose pull` every once in a while, to assure that you are using the latest images (which may contain bugfixes)

## [Using alternate ports](#alternate-ports)
By default, this demo will publish several services, binding to a number of ports on your computer in the process.  For example, the API-X proxy will bind to port `80`, the Fedora repository to port `8080`, and the Fuseki triplestore to port `3030`.

The default ports opened by the docker image for external access via your local machine are:
* 80 - Public access to repository via API-X
* 3030 - Fuseki (triple store)
* 8080 - Fedora internal port
* 8081 - API-X Loader Service
* 8983 - Solr
* 9080 - Reindexing
* 9102-9107 - Various Amherst services/extensions

Users may experience port conflicts with non-API-X services that are already running on their computer.  If shutting down the conflicting services is not an option, it will be necessary to map the API-X-related services to alternate ports.  This can be done by editing the environment file, `.env` (see the default file, which gives you an idea of the ports the demo will use,  [here](https://raw.githubusercontent.com/fcrepo4-labs/fcrepo-api-x-demo/master/.env)).  

For example, to publish the API-X proxy on port `8000` instead of the default port `80`, modify `PUBLIC_REPOSITORY_PORT=80` to read `PUBLIC_REPOSITORY_PORT=8000`, and modify `PUBLIC_REPOSITORY_BASEURI` to read `PUBLIC_REPOSITORY_BASEURI=http://localhost:8000/fcrepo/rest`.

If you wish to move the Fedora repository from port `8080` to port `10000`, modify:
* `FCREPO_PORT` to read `FCREPO_PORT=10000`
* `FCREPO_BASEURI` to read `FCREPO_BASEURI=http://fcrepo:10000/fcrepo/rest`
* `FCREPO_PROXYURI` to read `FCREPO_PROXYURI=http://fcrepo:10000/fcrepo`

**Note:** After saving your changes to `.env`, you will need to destroy and re-build the containers, performing a `docker-compose down` followed by `docker-compose up -d`.  Double-check your changes to the `.env` file, being aware of any potential typos!!

## Verification
*!!! The instructions below use the **default** URLs and ports found in the environment file (`.env`)*  
*!!! If you have modified the environment file, you must be sure to substitute the correct URL and port in the instructions below.*

* Visit `http://localhost:8080/fcrepo/rest` and see the Fedora REST API web page
* Visit `http://localhost/fcrepo/rest` and see a Fedora resource as exposed by API-X

Once you can verify that the environment is up and working, move on to some of the sample [API-X exercises](exercises/README.md).

# Image descriptions
This repository provides Dockerfiles for the following images that will be run in containers orchestrated by docker-compose:

* [acrepo](acrepo/LATEST) -  Provides a Karaf container with [repository services provided by Amherst College](https://gitlab.amherst.edu/acdc/repository-extension-services/) already installed and running.
* [apix](apix/0.3.0-SNAPSHOT) - Provides a Karaf container with API-X installed and configured in a useful way for the demo.
* [fcrepo](fcrepo/4.7.4-1) - Provides Fedora 4.7.4 with authentican and webac configured.
* [fuseki](fuseki/3.4.0) - Provides a triplestore index of API-X service documents and repository objects
* [toolbox](toolbox/4.7.2-1) - Contains acynchronous, message-based Camel services, including:
    * [Triple indexing](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox/tree/master/fcrepo-indexing-triplestore#fedora-indexing-service-triplestore)
    * API-X service document indexing
    * [SOLR indexing](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox/tree/master/fcrepo-indexing-solr#fedora-indexing-service-solr)
    * [Fixity](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox/tree/master/fcrepo-fixity#fedora-fixity-service)
    * [Reindexing](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox/tree/master/fcrepo-reindexing#fedora-reindexing-service)
    * [LDPath](https://github.com/fcrepo4-exts/fcrepo-camel-toolbox/tree/master/fcrepo-ldpath#fedora-ldpath-service)

# Developer Documentation

This section is for developers wishing to update and build images

## Naming conventions

In this repository, the `Dockerfile` for an image that contains a particular version of software should be placed in a directory that correponds to the version number.  For example, version `1.2.3` of `foo` should be found in `foo/1.2.3`.  

The suffix `-N` (as in `foo/1.2.3-1` or `foo/1.2.3-2`) is used to distinguish mutually incompatible images containing the same version of software.  That is to say, if the image changes in an incompatible manner (such as refactoring the names of configuration environment variables), then the version should be incremented by appending a suffix.  

## Building images

The `docker-compose.yaml` file contains `build` instructions that point to the directory containing the `Dockerfile` that builds the corresponding image.  For example:

      fcrepo:
        image: fcrepoapix/apix-fcrepo:4.7.4
        build: fcrepo/4.7.4
Note that due to the naming conventions above, the image tag will match the terminal directory in the `build` instuction.

To build all images, run `docker-compose build`

To push all images to dockerhub, run `docker-compose push`.

To build or push a specific image, add the _service_ name, as used by docker-compose; `docker-compose build fcrepo`.

## Reproducable builds

To avoid subtle bugs, all `Dockerfile`s should specify the hash of the base images they are derived from in the `FROM` statement.  For example:

    FROM tomcat:8.5.15-jre8@sha256:c8c45c1b463ecdae66bca3ffd8d6c75079a90fc4f3bfef061b4ba89f35e16b0f
    
This assures that all subsequent builds (regardless of host they are built on) use the exact same base image.  Updating the base image needs to be an explicit operation that resuults in a commit that updates the hash.

### Base images

`docker-compose build` only builds images defined in a given `docker-compose.yaml` file.  Some images (such as `apix-core`) are built on top of other images provied by api-x, such as `fcrepoapix/apix-karaf:4.0.9`.  Karaf would be considered a _base image_.  Normally, base images will simply be pulled in by dockerhub.  However, if specifically re-building a base image, or incrementing the version of one, then base images need to be specifically built and pushed to the dockerhub separately.

Base image directories (e.g. [karaf](karaf)) have their own `docker-compose.yaml` files that obey the same conventions.  So `docker-compose` can be used to build them as well. 

Once new base images are created, _they must be pushed to dockerhub before any other image can use them_.  So the procedure for incrementing the version of Karaf used for API-X would be:
1. Create a new `karaf/my.new.version` directory containg the updated Dockerfile
2. Build the Karaf image with `docker-compose build`
3. Push the Karaf image with `docker-compose push`
4. Edit the Dockerfiles of any images that are built on that base image.   Update the hash in the `FROM` section so that it matches the image you just built and pushed.  
5. Use `docker-compose build` to build and push the new images.
