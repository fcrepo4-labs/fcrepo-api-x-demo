# Evaluation Tasks
After you have installed the [prerequisite](https://github.com/birkland/fcrepo-api-x-demo/blob/doc-updates/README.md#requirements) software, [started](https://github.com/birkland/fcrepo-api-x-demo/blob/doc-updates/README.md#getting-started), and [verified](https://github.com/birkland/fcrepo-api-x-demo/blob/doc-updates/README.md#verification) that the milestone is up, it is time to perform the evaluation tasks!  

1. [Resources and URIs](01-Resources_and_URIs.md)
2. [Service Documents](02-Service_documents.md)
3. [Interacting with Exposed Services](03-Interacting_with_services.md)
4. [Loading Extensions](04-Loading_extensions.md)
5. [Ontologies and Binding](05-Ontologies_and_binding.md)

The tasks do not have to be done linearly, and they do not have to be done all at once.  Take your time, and feel free to stop the milestone at any time, and restart it later when you're ready to perform more tasks.  

# Running the evaluation

The [getting started](https://github.com/birkland/fcrepo-api-x-demo/blob/doc-updates/README.md#getting-started) documentation will get the demo running.  This section describes things to keep in mind while running the demo

## Starting, stopping, cleaning

The demo can be started by
    
    docker-compose up -d

_Stopping_ the containers shuts down all services, but keeps data on disk.  Once the demo has been stopped, it can be started at any time in order to resume where you left off

    # to stop
    docker-compose stop
    
    # to start/resume
    docker-compose up -d 
    
You can also completely destroy all containers including persisted data by:

    # Destroy/clean
    docker-compose down
   
    # Start a new environment from scratch
    docker-compose up -d

## Updating demo images

The API-X docker images are hosted on [dockerhub](https://docs.docker.com/docker-hub/).  Docker-compose downloads these images in order to start the docker containers, and also has the ability to update/patch the local images whenever the hosted images are updated.  Any bugs found and fixed in the demo will be pushed to dockerhub.  It's a good idea to periodically check for updates by doing:

    docker-compose pull

It will let you know if it pulls in any updates to images.  If so, you can simply re-start docker-compose to update the relevant images.  All demo-related data will be preserved (i.e. if you added or modified Fedora objects, they'll still be there when you update).  Do this by

    docker-compose up -d

## Accessing web services

By default, Docker exposes ports from running containers and makes them available to your local machine.  That is to say, if Fedora is running on port `8080` and its container exposes port `8080`, then Docker can expose port `8080` on your local machine such that the URI `http://localhost:8080` will be routed to the Fedora container.  If you have any locally running services, these can conflict with the ports used by the demo.  You either need to stop your local services, edit the `docker-compose.yaml` file so that the services use different ports, or use _docker-machine_.

The default ports are

* 80 - API-X
* 3030 - Fuseki (triple store)
* 8080 - Fedora
* 8081 - API-X Loader Service
* 9102-9107 - Various Amherst services


### Docker-machine URIs

_**This section is for docker-machine users only**.  All others can safely ignore this section, and simply cut and past URIs as present in the evaluation task instructions._

As mentioned in the verification section, throughout the evaluation instructions the bold localhost in URIs should be replaced with your docker-machine IP address if you’re running docker via docker-machine.  For example you may need to replace this

<pre>
http://<b>localhost</b>/fcrepo/rest/path/to/object
</pre>

with

<pre>
http://<b>192.168.99.100</b>/fcrepo/rest/path/to/object
</pre>
