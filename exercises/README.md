# [Evaluation Tasks](#tasks)
After you have installed the [prerequisite](../README.md#requirements) software, [started](../README.md#getting-started), and [verified](../README.md#verification) that the milestone is up, it is time to perform the evaluation tasks!  

1. [Resources and URIs](01-Resources_and_URIs.md)
2. [Service Documents](02-Service_documents.md)
3. [Interacting with Exposed Services](03-Interacting_with_services.md)
4. [Loading Extensions](04-Loading_extensions.md)
5. [Ontologies and Binding](05-Ontologies_and_binding.md)

The tasks do not have to be done linearly, and they do not have to be done all at once.  Take your time, and feel free to stop the milestone at any time, and restart it later when you're ready to perform more tasks.  

# [Running the evaluation](#running)

The [getting started](../README.md#getting-started) documentation will get the demo running.  This section describes things to keep in mind while running the demo

## [Starting, stopping, cleaning](#start-stop)

The demo can be started by

    docker-compose up -d

_Stopping_ the containers shuts down all services, but keeps data on disk.  Once the demo has been stopped, it can be started at any time in order to resume where you left off

    # to stop
    docker-compose stop

    # to start/resume
    docker-compose up -d

You can also completely destroy all containers including persisted data (e.g. Fedora objects created by these exercises) by:

    # Destroy/clean
    docker-compose down

    # Start a new environment from scratch
    docker-compose up -d

## [Updating demo images](#update-images)

The API-X docker images are hosted on [dockerhub](https://docs.docker.com/docker-hub/),  [here](https://hub.docker.com/u/fcrepoapix/dashboard/).  Docker-compose downloads these images in order to start the docker containers, and also has the ability to update/patch the local images whenever the hosted images are updated.  Any bugs found and fixed in the demo will be pushed to dockerhub.  It's a good idea to periodically check for updates by doing:

    docker-compose pull

It will let you know if it pulls in any updates to images.  If so, you can simply re-start docker-compose to update the relevant images.  All demo-related data will be preserved (i.e. if you added or modified Fedora objects, they'll still be there when you update).  Do this by

    docker-compose up -d

## [Non-default URIs and ports](#uris)

As mentioned in the [alternate ports](../README.md#alternate-ports) and [verification](../README.md#verification) sections, users may have modified their environment (the `.env` file) for a couple of reasons:
* You are a *docker-machine* user, and have modified the `APIX_BASEURI` to point to the IP address of your docker machine
* You have a port conflict, and have modified one or more API-X-related services to use a different port.

It is important to remember as you go through the exercises that you may need to modify the bold **localhost** URIs, especially if you have modified your `APIX_BASEURI` or `APIX_PORT`.

For example, if you have modified your APIX_BASEURI and API_PORT to `http://192.168.99.100:10000/fcrepo/rest` and `10000`, respectively, you must replace this

<pre>
http://<b>localhost</b>/fcrepo/rest/path/to/object
</pre>

with

<pre>
http://<b>192.168.99.100:10000</b>/fcrepo/rest/path/to/object
</pre>

To that end, each exercise carries the following reminder at the top of the page:

> *Please remember:*
> *The instructions below use the **default** URLs and ports found in the environment file*  
> *If you have modified the environment file, you must be sure to substitute the correct URL and port in the instructions below.*
