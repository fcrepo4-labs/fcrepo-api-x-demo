<h1><a href="#ex1" id="ex1" class="anchor">Exercise 1: Resources and URIs</a></h1>

> *Please remember:*
> *The instructions below use the **default** URLs and ports found in the environment file*  
> *If you have modified the environment file, you must be sure to substitute the correct URL and port in the instructions below.*

API-X supports a [proxy mode](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/uris-in-apix.md#api-x-intercepting-uris) that is used to support the [intercepting](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/execution-and-routing.md#intercepting-modality) extension modality, and link to a [service document](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/service-discovery-and-binding.md#service-document) for each resource which itself links to all services exposed on the object by API-X.  This exercise will explore the out-of-the-box of API-X proxy mode.  We'll call links directly to Fedora *direct* links, and links via the API-X proxy *proxied*.  Typically, the *proxied* URIs are made public (and shared/linked by others on the Internet at large), whereas the *direct* URIs are used by internal infrastructure for specific purposes.

<h2><a href="#ex1a" id="ex1a" class="anchor">A. Look at a Fedora object</a></h2>

Look at a Fedora object via direct and proxy URIs in order to compare and contrast representations:

1. Point your browser to the *proxied* fedora root object:  <code>http://**localhost**/fcrepo/rest</code>

2. Look at the list of children.  Note that their URIs all begin with the *proxied* base URI

3. Follow the link to the extensions child: <code>http://**localhost**/fcrepo/rest/apix/extensions</code>.  This is the API-X extension registry container.  You'll see that it already contains some extensions in it; we'll talk about these in another exercise.  Just like the root resource, all URIs are *proxy* URIs

4. Now look at the extensions resource at the command line via curl.  Let's look at a HEAD request:
    <pre>
    curl -I http://<b>localhost</b>/fcrepo/rest/apix/extensions
    </pre>

5. Look for a link header with relation "service", as in `Link: <http://localhost/discovery/apix/extensions>; rel="service"`.  API-X adds this link, which resolves to a [service document](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/service-discovery-and-binding.md#service-document) for the object.  Other exercises will explore the contents of service documents; right now we're mostly interested in the mechanics of retrieving headers and links.

6. Now perform the same HEAD request against the *direct* link to fedora.  Simply add the port 8080 to the URI:
    <pre>
    curl -I http://<b>localhost</b>:8080/fcrepo/rest/apix/extensions
    </pre>
  - Notice that there is no longer a "service" link relation; but other links are the same

7. Now view the direct link in the browser.  It's the same as in step 3, except for the URIs.  All URIs are also *direct* links.

<h2><a href="#ex1b" id="ex1b" class="anchor">B. Look at proxied binary resources</a></h2>

Binary resources in Fedora are a little more complicated than plain RDF objects.

1. Navigate to the root proxy URI in your browser <code>http://**localhost**/fcrepo/rest</code>

2. Create a container named _images_
   * If using the the UI, in _Create New Child Resource_ type `images` into the _identifier_ text box, and make sure `container` is selected from the `type` dropdown menu.  If no such controls are visible, click the red _Toggle actions_ button.
  * If using the command line, do
    <pre>
    curl -X POST -H "Slug: images" http://<b>localhost</b>/fcrepo/rest
    </pre>

3. Upload a binary image to the _images_ container, and give it a reasonable name.  
  * If using the UI, in _Create New Child Resource_, select Type: _binary_, Identifier: _filename.jpg_ (or whatever you wish to call it).  When you select _binary_, you'll be prompted to upload an image from your local machine.  Choose an arbitrary image, or download one from the internet to use.  Feel free to do a Google Image Search for "cows".
  * If using the command line, for a file named `filename.jpg` in your current directory, do
  <pre>
  curl -i -X POST --data-binary "@filename.jpg" -H "Slug: filename.jpg" -H "Content-Disposition: attachment; filename=\"filename.jpg\"" http://<b>localhost</b>/fcrepo/rest/images
  </pre>

4. When you upload a binary from the UI, you will be redirected to the binary's _metadata_ resource.  Via the command line, you will be returned a `Location` header which points to the newly created binary resource itself.  Currently in Fedora, the URIs of a binary and its properties/metadata are distinct. Let's explore the metadata resource first.  Its URI will be something like: <code>http://**localhost**/fcrepo/rest/images/filename.jpg/fcr:metadata</code>.  Look at its headers using:
    <pre>
    curl -I http://<b>localhost</b>/fcrepo/rest/images/filename.jpg/fcr:metadata
    </pre>
You should see a link to a service document.  This is a service document for the _metadata_ of the binary resource.  The service document for the binary resource itself can be found by exploring _its_ headers.  Before doing that, realize that you shouldn't try to construct a metadata URI given a binary resource URI or vice versa based on _a priori_ knowledge of how a particular Fedora implementation constructs its URIs.  Instead, look for `rel=describes` or `rel=describedby` headers, and follow those links.  When retrieving the headers for the metadata resource above, you should have seen a `rel=describes` link which points to the binary it describes.  Do a HEAD request on it
    <pre>
    curl -I http://<b>localhost</b>/fcrepo/rest/images/filename.jpg
    </pre>
It too has a link to a service document; one that enumerates all services that can operate on that binary resource.  
