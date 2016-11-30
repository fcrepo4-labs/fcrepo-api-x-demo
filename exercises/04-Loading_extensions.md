# Exercise 4: Loading and deploying extensions

The current API-X implementation uses LDP containers in Fedora as registries for extensions, services, and ontologies.  It's possible to add an extension to API-x simply by depositing the right kind of objects into the right containers.  However, there's an even easier way.  Included in API-X is a Loader service that allows service instances to manually or self-register.  This set of exercises explores this loader to deploy extensions into API-X.

## A. Registries.  
Let's first take a look at the contents of the [service registry](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/service-discovery-and-binding.md#service-registry) container in API-X, in order to get an appreciation of what the loader does.  

1. Take a look at the service registry container.  Enter its URI in your browser: <code>http://<b>localhost</b>/fcrepo/rest/apix/services</code>
  * This container, like all of API-X's internal LDP registries, is automatically created by API-X upon startup.  

2. The service registry is an LDP indirect container.  The API-X service ontology specifies a relationship `containsService` to indicate membership in the service registry.  Compare the URIs of the resources pointed to by `containsService` vs `ldp:contains`.  As you can see, [service](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/service-discovery-and-binding.md#apixservice) URIs are distinct from fedora [resource](http://fedora.info/definitions/v4/2016/10/18/repository#Resource) URIs.  Why do you think that is?

3. Click on the service URI for the FITS service: <code>http://**localhost**/fcrepo/rest/apix/services/extensions-fits#service</code>
You'll see the fits service page.  At the bottom, notice the "other resources" section.  Click on the _instances_ link:
<code>http://**localhost**/fcrepo/rest/apix/services/extensions-fits#instances</code>

4. Look for the property `hasEndpoint`.  This is a URI to a web service that implements the FITS service.  Exercise 3A had us exploring the FITS service.  Under the covers, API-X was accepting requests at exposed service URIs like
<code>http://**localhost**/services/images/filename.jpg/svc:fits</code> and forwarding them to the underlying implementation at
`http://acrepo:9106/fits` The notion of these underlying implementation services will become relevant to this loader exercise.
  * The underlying implementation of the fits service is a Java-based Apache Camel route which acts as a mediator between the client and an instance of FITS running in a Tomcat container.  Take a look at [this code segment](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/java/edu/amherst/acdc/exts/fits/FitsRouter.java#L49-L62) for a glimpse at how an underlying service impl handles requests.  On GET, it reads the URI of the [relevant resource](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/uris-in-apix.md#resource-scoped-services), and ultimately feeds its contents into the FITs service.
  * Notice the [OPTIONS handling code](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/uris-in-apix.md#resource-scoped-services).  This will become important shortly.
  
## B. The loader extension.  
The loader service is given the URI of an underlying implementation service.  It performs an OPTIONS request against that URI.  If the response returns an extension definition document, it places/updates that extension into the extension registry, creates appropriate entries in the service registry, and registers the given URI (the underlying service URI) as an instance of the appropriate service.  Activity 4A explored how underlying service URIs appear in the registry.  See the [loader documentation](https://github.com/fcrepo4-labs/fcrepo-api-x/tree/master/fcrepo-api-x-loader) for more information.

The loader is itself registered as an extension in API-X.  In particular, it is a _[repository-scoped](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/uris-in-apix.md#repository-scoped-services)_ extension since there is only one loader for the whole repository.  Let's take an initial look at it.

1. Look at the service document for the repository root resource; <code>http://<b>localhost</b>/fcrepo/rest</code>, and find the loader endpoint URI
    <pre>
    curl -I http://<b>localhost</b>/fcrepo/rest
    
    curl http://<b>localhost</b>/discovery/
    </pre>
        
2. Look for an instance of `http://fedora.info/definitions/v4/api-extension#LoaderService`.  In this case, its endpoint uri is <code>http://localhost/services//apix:load</code>.  Enter that in your browser.  You'll see a very basic html form, we will explore that shortly.

3. Now take a look the loader's extension definition: `http://localhost/fcrepo/rest/apix/extensions/load`
Take particular note of two properties:
  * `exposesServiceAt` points to a literal that begins with a slash.  This is the extension's way of indicating a repository-scoped service.
  * `bindsTo` specifies the class of resource the extension [binds to](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#extension-binding).  In this case, the Fedora ontology defines a repository root class.  By binding to this class, repository-scoped extensions can be discoverable from the root repository resource in its service document. 

## C. Loading an extension manually.  
We will use the html form provided by the loader extension to manually provide it with an underlying service URI.  We'll watch an extension being loaded

1. Bring up the loader page in a browser: <code>http://localhost/services//apix:load</code>

2. In the text box, type the URI to an underlying implementation service: `http://acrepo:9102/jsonld?apix.scope=resource`
  * This is the URI to a service that is running as part of the demo, but is not yet registered as an extension. 
  * The hostname is 'acrepo'.  This is an artifact of how Docker resolves host names; the underlying service is running in a Docker container whose hostname, according to Docker’s internal DNS service, is 'acrepo'.  
  * The query parameter apix.scope=resource is an implementation detail of this specific service.  It is able to be registered as a resource-scoped extension, or a repository-scoped extension.  The parameter tells it which one.  See [this code snippet](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-jsonld/src/main/java/edu/amherst/acdc/exts/jsonld/EventRouter.java#L55-L59) to get a sense on how this particular service uses the parameter.  If repository-scoped, it will register [this extension](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-jsonld/src/main/resources/options.ttl).  If resource-scoped, [a different one](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-jsonld/src/main/resources/options_resource.ttl) 

3. Click the "submit" button to tell the loader to process that URI.  If successful, you'll be redirected to a Fedora resource corresponding to the newly-loaded extension.  In our case, we just loaded a JSON-LD compaction extension.

4. Take a look at the API-X logs; The last log entry should tell you what the loader service just did.  Does it make sense?
    <pre>
    docker logs apix
    </pre>

5. From the looks of the extension definition document shown to you after loading the extension (most likely <code>http://**localhost**/fcrepo/rest/apix/extensions/jsonld</code>), you just loaded a service of type
`http://acdc.amherst.edu/extensions#JsonLDService`.  We can also see that it binds to (all) repository resources, and it's a resource-scoped extension.  Can you see how we know that from the extension definition?

6. Now, pick an arbitrary object (say the extension you just created; <code>http://**localhost**/fcrepo/rest/apix/extensions/jsonld</code>).  Look at its service doc, and look for the endpoint URI for the jsonld service on it.  In this case, it's <code>http://localhost/services/apix/extensions/jsonld/svc:compact</code>
Follow that URI.  The result should be a compact Json-LD representation of the resource!

## D. Auto-loading extensions.  
The loader service can accept underlying service URIs in `application/x-www-form-urlencoded` (for html forms) or text/plain.  A service can be configured to POST its own URI to the loader service upon startup to self-register.

1. Take a look at [this section of camel route xml](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/resources/OSGI-INF/blueprint/fits-service.xml#L30-L54).  This is how the fits service (which happens to use Apache Camel) self-registers.  Let's dissect it a little bit to understand what is happening.
  * This route is [configured to trigger](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/resources/OSGI-INF/blueprint/fits-service.xml#L32) once, upon startup
  * It ultimately [sends a request](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/resources/OSGI-INF/blueprint/fits-service.xml#L51) to a configurable URI of the loader service
  * It POSTs [its own URI](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/resources/OSGI-INF/blueprint/fits-service.xml#L45) in the body of an http request, with content-type [text/plain](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/resources/OSGI-INF/blueprint/fits-service.xml#L45).  The loader service accepts plain text POSTS, or urlencoded forms.  Programatically, plain text is easier to deal with.
  * If the request fails (say, the loader service is not up yet), the [error handler](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-fits/src/main/resources/OSGI-INF/blueprint/fits-service.xml#L33-L37) will attempt to re-try a certain number of times until it succeeds
  
As API-X operates over HTTP, the implementation langage of services is irrelevant.  Any underlying service implementation that wishes to self-register with API-X would likely perform a similar set of steps.