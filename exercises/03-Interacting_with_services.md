<h1><a href="#ex3" id="ex3" class="anchor">Exercise 3: Interacting with Services</a></h1>

> *Please remember:*
> *The instructions below use the **default** URLs and ports found in the environment file*  
> *If you have modified the environment file, you must be sure to substitute the correct URL and port in the instructions below.*

This set of tasks explores interacting with a variety of extensions that provide a variety of different "APIs".  

<h2><a href="#ex3a" id="ex3a" class="anchor">A. Passive resource-scoped service</a></h2>
The simplest API for an exposed service is simply returning something useful in response to a GET request.  The "fits" extension feeds the contents of a binary object in Fedora to an instance of the [FITS](http://projects.iq.harvard.edu/fits/home) web service in order to extract metadata about its contents.  The end result is an XML document providing various metadata about the binary resource.

1. Deposit a binary object into Fedora, such as an image or video, or simply use the one from [exercise (1)](01-Resources_and_URIs.md#ex1b).  Let's say the URI is <code>http://**localhost**/fcrepo/rest/images/filename.jpg</code>

2. Use curl to look at its headers, get the URI for the service document, and follow that link to look at the service document.
  1. Get the headers:
  <pre>
  curl -I http://<b>localhost</b>/fcrepo/rest/images/filename.jpg
  </pre>
  2. Now the service document:
  <pre>
  curl http://<b>localhost</b>/discovery/images/filename.jpg
  </pre>

3. Look for the "fits" service named `http://acdc.amherst.edu/ns/registry#fits`.  Get its service endpoint URI; which should be something like <code>http://**localhost**/services/images/filename.jpg/svc:fits</code>

4. Simply copy and paste the fits endpoint URI into your browser.  It may take a few seconds for the initial load; you know how slow Java services are when they're used for the first time after a cold start.
  * You should get back a plausible metadata about the file. Feel free to upload different kinds of binaries and look at the resulting output
  * Note that in this example, each time you call the FITS service a new XML document is being created from the binary. It is not retrieving a document that already exists in the repository, nor will it store the metadata that is retrieved.  

5. Now, look at the service document for an rdf resource in Fedora (a container, not a binary), such as <code>http://<b>localhost</b>/fcrepo/rest/apix/extensions</code>.  Do you see the fits service in the discovery document?  Can you form a hypothesis as to why or why not?  

6. The extension definition for the fits service can be found as a Fedora object at <code>http://**localhost**/fcrepo/rest/apix/extensions/fits</code>.  Look for the `bindsTo` relationship.  Does this agree with your understanding of why the fits service appears in some service documents, and not others?

7. At this stage, you can probably figure out how API-X constructs its service endpoint URIs.  What happens when you attempt to coerce a URI that doesn't exist in a service document?  For example, try <code>http://**localhost**/services/apix/extensions/svc:fits</code>

<h2><a href="#ex3b" id="ex3b" class="anchor">B. Links within exposed services</a></h2>

Exposed service endpoint URIs are really just entrypoints; they link to services that may produce resources that link to other resources within that service, as seen in [HATEOAS](http://restcookbook.com/Basics/hateoas/)-style APIs.  So the ability for an exposed service to be able to link within itself is important.  This task presents a very simple example.  The "xml" extension provides xml-based MODS and DC representations of a Fedora resource.  It presents users with a choice of formats in the form of an html document that links to URIs for the different formats.

1. Fetch the service document for an arbitrary RDF fedora resource, and look for a service of type `http://example.org/services/RdfVisualization`.  For example, on resource <code>http://**localhost**/fcrepo/rest/apix/extensions</code>
that's <code>http://**localhost**/services/apix/extensions/demo:rdfvis/</code>

2. Note the trailing slash in the URI, it's [important](https://cdivilly.wordpress.com/2014/03/11/why-trailing-slashes-on-uris-are-important/) for using relative URIs- we'll be exploring that shortly.  How did API-X know how to include a trailing slash for this particular exposed service?  Take a look at its extension definition to find out.  
  1. Look for the `exposesServiceAt` property of the extension definition in your browser: <code>http://**localhost**/fcrepo/rest/apix/extensions/rdfVis</code>
  2. Compare to an extension whose service URIs do not have the trailing slash: <code>http://**localhost**/fcrepo/rest/apix/extensions/fits</code>

3. Continuing on from step 1, follow the service endpoint URI for the xml extension in your browser: <code>http://**localhost**/services/apix/extensions/demo:rdfvis/</code>
You'll see a simple html document that presents two choices.  In your browser, view its source.  As you can probably guess, this is just a static html resource; being able to use relative URIs lets us get away with that easily.

4. Follow the link to "View as image".  This extension renders the RDF in the repository resource as an image.  For our purposes, we're more interested in looking at its URI:
<code>http://**localhost**/services/apix/extensions/demo:rdfvis/image</code>
  * The underlying service that implements this extension happens to be implemented in PHP.  [These lines of code] (https://github.com/birkland/fcrepo-api-x-demo/blob/acrepo-1.1.0/extensions/rdfvis/1.0.0/www/index.php#L15-L30) implement the routing logic with respect to the incoming service request.  If no path is present (or it doesn't match), the html present after this code block will be displayed.
  * In exercise 4, we will explore extension deployment and registering services in a little more detail.  Suffice it to say, the underlying implementation of the rdf visualization service in this demo is `http://172.22.0.6:12000/rdfVis` (or whatever the address it happens to be in your local environment).  A request to API-X <code>http://**localhost**/services/apix/extensions/demo:rdfvis/**image**</code> gets forwarded via the API-X to <code>http://172.22.0.6:12000/rdfVis**/image**</code>.  Read the [execution engine](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/execution-and-routing.md#generic-endpoint-proxy) documentation to get a greater understanding of the interaction between API-X and the underlying service.

<h2><a href="#ex3c" id="ex3c" class="anchor">C. Query Parameters may be part of the API exposed by an extension</a></h2>

In this exercise, we'll take a look at a fascinating image manipulation extension that is a thin wrapper around the ImageMagick [convert](https://www.imagemagick.org/script/convert.php) utility.

1. Load a jpeg image into the repository, and note its URI.  For example: <code>http://**localhost**/fcrepo/rest/images/filename.jpg</code>

2. Look at the image resource's service document, and find the endpoint URI that corresponds to the service of type:
`http://acdc.amherst.edu/ns/registry#ImageService`.  Find its endpoint and put it in your browser: <code>http://**localhost**/services/images/filename.jpg/svc:image</code>

3. You should simply see the image in your browser.  According to its [documentation](https://gitlab.amherst.edu/acdc/repository-extension-services/tree/master/acrepo-exts-image) this image extension accepts a URL parameter called "options", the content of which is simply applied to the convert command line.  So let's re-size the image by adding an appropriate query param:
<code>http://**localhost**/services/images/filename.jpg/svc:image?<em>options=-resize 200x200!</em></code>
  1. Maybe we want to invert the colors.  Try doing that: <code>http://**localhost**/services/images/filename.jpg/svc:image?<em>options=-negate</em></code>
  2. Negate and flip:<code>http://**localhost**/services/images/filename.jpg/svc:image?<em>options=-negate -flip</em></code>

Much like the xml services from [(B)](#ex3b), API-X  is simply passing along the query parameters unmodified to the underlying image manipulation service.
