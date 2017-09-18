<h1><a href="#ex2" id="ex2" class="anchor">Exercise 2: Service Documents</a></h1>

> *Please remember:*
> *The instructions below use the **default** URLs and ports found in the environment file*  
> *If you have modified the environment file, you must be sure to substitute the correct URL and port in the instructions below.*
> *Authentication is enabled.  Use the username `fedoraAdmin` and password `secret3` if prompted.*

[Service documents](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/service-discovery-and-binding.md#service-document) list and describe the services that API-X extensions expose on a given object, using the API-X [service ontology](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/fcrepo-api-x-ontology/src/main/resources/ontologies/apix-service.ttl).  [Evaluation task (1)](01-Resources_and_URIs.md#ex1) explored looking at HTTP headers, which is the mechanism by which API-X links to service documents.  This set of evaluation tasks involves exploring and using these documents to locate extensions.  Although each task involves manual steps, consider what it would take to perform each task programmatically in your favorite language.  Bonus points for actually writing a program that interacts with service documents.

<h2><a href="#ex2a" id="ex2a" class="anchor">A. Retrieve and analyze a service document</a></h2>

1. Pick an arbitrary object in the repository, and perform a HEAD request against its _proxied_ URI.  For example, the repository root:
    <pre>
    curl -u fedoraAdmin:secret3 -I http://<b>localhost</b>/fcrepo/rest
    </pre>

2. Look at the Link headers for the `service` relation, as in <code>Link: &lt;http://<b>localhost</b>/discovery/&gt;; rel="service"</code>

3. Follow the link to get the service document.  The default media type is text/turtle
<pre>
curl -u fedoraAdmin:secret3 http://<b>localhost</b>/discovery/
</pre>

4. Look at the document for the following:
  1. The endpoint for each exposed service is linked to via the `hasEndpoint` relationship.  If you are looking at the service document of the root resource as described in the running example, you should see at least two endpoints <code>http://<b>localhost</b>/services//apix:load</code>
and
<code>http://<b>localhost</b>/services/demo:rdfvis/</code>
(as we will see later all slashes, including trailing slashes, are significant).  Can you look at the document and find these services?
  2. The type/kind/name of service is indicated by the `isServiceInstanceOf` relationship.  The two services we noted above are instances of `http://fedora.info/definitions/v4/api-extension#LoaderService` and
`http://example.org/services/RdfVisualization`.  Can you look at the document and come to the same conclusion?
  3. An exposed service is *resource-scoped* if it operates on a specific object.  That is to say, the URI of a resource-scoped service points to a resource whose representation is some function or derivation of a specific object in the repository.  This is indicated by the `isFunctionOf` relationship.  Of the two services we have been looking at, which one is resource-scoped, and which one is not?

<h2><a href="#ex2b" id="ex2b" class="anchor">B. Look for a specific service in a service document</a></h2>

It's anticipated that a common use case for service documents involves searching for the endpoint URI to a service of a known type; e.g "Where is the image shrinking service for this particular object"

1. Upload an image to the repository as a binary resource, or simply use the one from [exercise (1)](01-Resources_and_URIs.md#ex1b).  Let's say its URI is `http://localhost/fcrepo/rest/images/filename.jpg`

2. Use curl to look at its headers, get the URI for the service document
  <pre>
  curl -u fedoraAdmin:secret3 -I http://<b>localhost</b>/fcrepo/rest/images/filename.jpg
  </pre>

3. ...and follow that link to look at the service document.
  <pre>
  curl -u fedoraAdmin:secret3 http://<b>localhost</b>/discovery/images/filename.jpg
  </pre>

4. Look for the "image" service; named `http://acdc.amherst.edu/ns/registry#ImageService`
Is this a resource-scoped service?  What is the URI to its service endpoint?

5. Using your favorite programming language, can you find the endpoint URI of the image service programmatically, given only the resource URI `http://localhost/discovery/images/filename.jpg`?  How easy or difficult is it to do so?
