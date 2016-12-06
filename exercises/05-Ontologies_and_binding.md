<h1><a href="#ex5" id="ex5" class="anchor">Exercise 5: Ontologies and binding</a></h1>

This exercise explores aspects related to [binding](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#extension-binding) services to repository objects, as well as management of owl ontologies.  The [bindsTo](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#apixbindsto) relationship specifies the class of objects that an extension binds to.  The simplest case is when an object has an `rdf:type` property that matches a given extension.  Otherwise, [owl reasoning](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#owl-reasoning) may be used to infer membership in a particular class based on the characteristics/properties of a given repository object.  

<h2><a href="#ex5a" id="ex5a" class="anchor">A. Simple binding by type</a></h2>

1. The Fedora repository ontology defines a [RepositoryRoot](http://fedora.info/definitions/v4/2016/10/18/repository#RepositoryRoot) class, used for describing those objects that function as the root node of the repository.  Take a look at the repository root resource and verify that it's a member of this class: <code>http://**localhost**/fcrepo/rest/</code>.  
  * This class membership is a server-managed property.  It cannot be modified by the user.

2. Take a look at the [extension definition](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/fcrepo-api-x-loader/src/main/resources/options.ttl) used by the loader service, or look at its representation as a Fedora object: <code>http://**localhost**/fcrepo/rest/apix/extensions/load</code>.  Do you see how it binds to the repository root?  Is it clear from the extension definition that this is a repository-scoped extension?
  * As we saw in exercise 4, the API-X loader is a repository-scoped service; there is only one endpoint for the whole repository.  Although it's perfectly fine to link to a repository-scoped service from any object, we specifically want it to be discoverable only via the root repository resource, because we view it as a "capability of the repository".  


3. The Amherst [PCDM extension](https://github.com/birkland/repository-extension-services/tree/apix-demo/acrepo-exts-pcdm) traverses repository objects to produce a single graph from related objects.  We're not concerned with its functionality at the moment, just binding to the extension.  Its extension definition is [here](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-pcdm/src/main/resources/options.ttl).  As you can see, it binds to `pcdm:Object`.  Let's add that to an object in the repository and see the extension binding at work.
  1. Look at the service document of an object in the repository.  For the sake this example, let's use the PCDM extension definition object.  Look at its service document and verify that the pcdm extension is not exposed by it: <code>http://**localhost**/discovery/apix/extensions/pcdm</code>
  2. Now modify the object to explicitly add `rdf:type pcdm:Object`; <code>http://**localhost**/fcrepo/rest/apix/extensions/pcdm</code>
    * If using Fedora's UI, in the _Update Properties_ text box, scroll down to where you see `INSERT { }`.  Between the brackets add the appropriate triples, so that it looks like this:  <code>INSERT {&lt;&gt; rdf:type &lt;<span>http://pcdm.org/models#Object</span>&gt;}</code>, and click _update_
    * If using the command line, do
    <pre>
    curl -X PATCH -H "Content-Type: application/sparql-update" --data "INSERT {&lt;&gt; &lt;<span>http://www.w3.org/1999/02/22-rdf-syntax-ns#type</span>&gt; &lt;<span>http://pcdm.org/models#Object</span>&gt;} WHERE {}" http://localhost/fcrepo/rest/extensions/pcdm
    </pre>
    * In either case, you need to write out the whole pcdm namespace, rather than using a convenient prefix like `pcdm:`.  This is due to the relative difficulty of defining prefixes and namespaces in Fedora, which is outsisde of the scope of this exercise.
  3. Look again at the service document of the object.  Do you see the pcdm service endpoint now?  Good!

<h2><a href="#ex5b" id="ex5b" class="anchor">B. Binding by inference</a></h2>

OWL inference allows binding extensions to objects based upon their characteristics, rather than requiring objects to explicitly declare an `rdf:type` that matches an extension.  This allows considerable flexibility deploying extensions over an existing repository.  A [PCDM extension](https://github.com/birkland/repository-extension-services/tree/apix-demo/acrepo-exts-pcdm) simply describes the kinds of objects it can operate over according to some ontology (e.g. PCDM objects), and the API-X framework utilises OWL reasoning to determine which objects in the repository fit that description.  It sounds complicated, but it's not.

As we saw earlier, the PCDM extension operates over any repository objects that are a `pcdm:Object`.  The [PCDM ontology](http://pcdm.org/models#Object) describes this concept, and properties that are relevant to it.   Notice a property [hasFile](http://pcdm.org/models#hasFile);  It has a _domain_ of `pcdm:Object`.  That is to say, a resource that has a `hasFile` property can be inferred to be a `pcdm:Object` according to the PCDM ontology.  Let's explore how API-X can use this fact for extension binding.

1. Create an object we want to bind the PCDM extension to.  Earlier exercises had us creating an _images_ container and depositing images into it.  If you don't still have these in your repository from the, add them.  For the sake of this exercise, let's assume the container is <code>http://**localhost**/fcrepo/rest/images</code>, and it has a binary in it <code>http://**localhost**/fcrepo/rest/images/filename.jpg</code>

2. Add a PCDM `hasFile` relationship to the container, which points to the image.
  * If using Fedora's UI, in the _Update Properties_ text box, scroll down to where you see `INSERT { }`.  Between the brackets add the appropriate triples, so that it looks like this:  <code>INSERT {&lt;&gt; &lt;<span>http://pcdm.org/models#hasFile</span>&gt; &lt;<span>http://**localhost**/fcrepo/rest/images/filename.jpg</span>&gt;}</code>, and click _update_
  * If using the command line, do
  <pre>
  curl -X PATCH -H "Content-Type: application/sparql-update" --data "INSERT {&lt;&gt; &lt;<span>http://pcdm.org/models#hasFile</span>&gt; &lt;<span>http://**localhost**/fcrepo/rest/images/filename.jpg</span>&gt;} WHERE {}" http://localhost/fcrepo/rest/images
  </pre>

3. Now look at the service document for the _images_ container <code>http://**localhost**/discovery/images</code>.  Do you see the PCDM extension?  Why or why not?

4. The PCDM ontology tells us that we can infer `pcdm:Object` from `pdcm:hasFile`.  However, API-X has no _a priori_ notion of the PCDM ontology, or our intent to use it for reasoning.  The mechanism by which ontologies are imported for the sake of reasoning is `owl:imports`.  API-X correspondingly [uses that property](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#minimal-graph-for-reasoning) for reasoning during extension binding.  Take a look at the pcdm extension object <code>http://**localhost**/fcrepo/rest/apix/extensions/pcdm</code>.  Do you see any imports statements?

5.  Add an `owl:imports` statement to the extension definition which links to the pcdm ontology.
  * If using Fedora's UI, in the _Update Properties_ text box, scroll down to where you see `INSERT { }`.  Between the brackets add the appropriate triples, so that it looks like this:  <code>INSERT {&lt;&gt; &lt;<span>http://www.w3.org/2002/07/owl#imports</span>&gt; &lt;<span>http://pcdm.org/models#</span>&gt;}</code>, and click _update_
  * If using the command line, do
  <pre>
  curl -X PATCH -H "Content-Type: application/sparql-update" --data "INSERT {&lt;&gt; &lt;<span>http://www.w3.org/2002/07/owl#imports</span>&gt; &lt;<span>http://pcdm.org/models#</span>&gt;} WHERE {}" http://localhost/fcrepo/rest/apix/extensions/pcdm
  </pre>

6. Now that the PCDM extension imports the PCDM ontology, API-X can use it for reasoning.  Take another look at the service document of the _images_ container we added a `hasFile` property to; <code>http://**localhost**/discovery/images</code>.  A PCDM service endpoint should now be present!

7. Suppose we inverted the `pcdm:hasFile` relation.  Instead of adding `pcdm:hasFile` to a container, we instead add `pcdm:fileOf` on the _file_ pointing to a container.  Can API-X reason that the container is a `pcdm:Object` based on this?  At present, it cannot.  See [minimal graph for reasoning](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#minimal-graph-for-reasoning) for an explanation.  When attempting to bind a given object to an extension, API-X will only inspect the contents of the object -- not objects related to it.  

<h2><a href="#ex5c" id="ex5c" class="anchor">C. Extensions as ontologies</a></h2>

In the previous example, we used a concept from an established ontology (`pcdm:Object`) in order to bind extensions via OWL inference.  We used `owl:imports` to import the ontology, and pointed to the ontology's URI.  Being an established ontology following best practices, its URI is resolvable, and API-X can fetch its contents for the purpose of reasoning.  This exercise explores what we do if an extension author can describe the kinds of objects an extension shall bind to using known vocabularies, but unlike `pcdm:Object` is not a concept defined by a term in any specific ontology.

1. An earlier exercise explored the Amherst image service.  Take a look at the [extension definition](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-image/src/main/resources/options.ttl) used by the image service. Let's analyze it
  * The extension binds to [a class](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-image/src/main/resources/options.ttl#L13-L15) that is locally defined in the extension definition.
  * The class it binds to describes [binary](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-image/src/main/resources/options.ttl#L16) resources that have [MIME type properties](https://github.com/birkland/repository-extension-services/blob/apix-demo/acrepo-exts-image/src/main/resources/options.ttl#L17) that match `image/tiff`, `image/jpeg`, or `image/jp2`
  * API-X uses inference to conclude that any binary object with at least one matching MIME type is a member of this locally-defined class, and therefore should bind to the Image extension.
  * This example demonstrates why the API-X documentation describes extension definitions as [owl documents](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#extension-definition) in their own right.

2. Take a look at the image service's extension definition.  Do that through the UI using this specific procedure.  Look at the extension registry container <code>http://**localhost**/fcrepo/rest/apix/extensions</code>.  Examine the list of children and **click** on the link to the image extension <code>http://**localhost**/fcrepo/rest/apix/extensions/image</code>.  Do you notice anything funny?  It's a binary resource!
  * The loader service persists extension definitions as binary resources if they contain blank nodes (this behaviour may be turned on or off by configuration of API-X)
  * Fedora does not persist blank nodes in the rdf state of objects in the repository.  Instead, it [skolemizes](https://jira.duraspace.org/browse/FCREPO-2108) them.
  * In OWL, blank nodes have specific meaning as an existential variable (e.g "there exists some X.."), so they need to be preserved.  The only way to do that in the current Fedora implementation is as a binary.
  * API-X does not care about the distinction between "object" and "binary" when looking at extensions or ontologies in the repository.  All it is concerned about is that an extension definition is available as a web resource as RDF.  The choice by the loader to persist certain extensions as binary is a pragmatic choice.

<h2><a href="#ex5d" id="ex5d" class="anchor">D. The Ontology registry</a></h2>

API-X contains an ontology registry as a core component.  Ontologies in this registry are used in preference to ontology resources on the web.  This behavior supports two primary use cases:
  * Retrieving ontologies on the web introduces risk.  Network or infrastructure interruptions may render an ontology temporarily irretrievable, or introduce unacceptable latency.  While caching helps, placing ontologies into the repository for the sake of durability guarantees their availability
  * The public version of an ontology may not be optimal for reasoning.  It may contain terms and definitions that are irrelevant, or may contain axioms that complicate reasoning (e.g. OWL full, or abuse of RDFS).  A small subset of an existing ontology may be all that is needed to support extension binding reasoning; the ontology registry is a place where such ontologies may be persisted.

Let's explore the API-X ontology registry and associated services!

1. If you haven't done so, please complete [exercise B](#ex5b) above.  In particular, make sure you have added an `owl:imports` statement to the PCDM ontology, and that it works as advertised.

2. Look at the contents of the ontology registry container: <code>http://**localhost**/fcrepo/rest/apix/ontologies</code>.  Notice that is contains the PCDM ontology <code>http://**localhost**/fcrepo/rest/apix/ontologies/pcdm.org-models</code>:
  * API-X can be configured to persist all ontologies referenced by extensions.  API-X listens for messages that correspond to adding or updating extensions.  When a new ontology is imported, API-X asynchronously fetches the ontology and persists it in the repository.
  * Recall that the PCDM extension imports `http://pcdm.org/models#`, not <code>http://**localhost**/fcrepo/rest/apix/ontologies/pcdm.org-models</code>.  This is as expected;  API-X maintains an internal mapping between ontology IRI to resource URI for ontology lookup.

3. Notice that the PCDM ontology resource is a binary <code>http://**localhost**/fcrepo/rest/apix/ontologies/pcdm.org-models</code>. For the reasons discussed above, API-X persists ontologies as binaries in the registry as a matter of course.  

4. Let's add a more complicated ontology to an extension and see what happens.  Import the [PREMIS](http://www.loc.gov/premis/rdf/v1#) ontology into the PCDM extension
   * If using Fedora's UI, in the _Update Properties_ text box, scroll down to where you see `INSERT { }`.  Between the brackets add the appropriate triples, so that it looks like this:  <code>INSERT {&lt;&gt; &lt;<span>http://www.w3.org/2002/07/owl#imports</span>&gt; &lt;<span>http://www.loc.gov/premis/rdf/v1#</span>&gt;}</code>, and click _update_
  * If using the command line, do
  <pre>
  curl -X PATCH -H "Content-Type: application/sparql-update" --data "INSERT {&lt;&gt; &lt;<span>http://www.w3.org/2002/07/owl#imports</span>&gt; &lt;<span>http://www.loc.gov/premis/rdf/v1#</span>&gt;} WHERE {}" http://localhost/fcrepo/rest/apix/extensions/pcdm
  </pre>

5. Take a look at the apix logs.  Notice several INFO statements related to persisting or indexing ontologies.  You may see exceptions due to errors retrieving some resources.  Fetching the PREMIS ontology seems particularly prone to timeout errors, which illustrates a use case for persisting ontologies in the repository.
  * <pre>
    docker logs apix
    </pre>

6. Look at the contents of the ontology registry container now: <code>http://**localhost**/fcrepo/rest/apix/ontologies</code>.  If every download was successful, you should see over 25 ontologies!  When parsing an ontology for the sake of reasoning, API-X follows all `owl:imports` links in order to form a closure of statements.  The ontology persistence service persists any ontology referenced by API-X.  Since API-X builds a closure of all `owl:imports` statements, all ontology resources encountered when building this closure are persisted.  For PREMIS, it's huge.
  1. In a new terminal window, follow the Fedora logs in realtime:
  <pre>
  docker logs -f fcrepo
  </pre>
  2. In another window, look at an arbitrary object's service document.  Let's look at the repository root: <code>http://**localhost**/discovery/</code>.  You'll see lots of GET requests in the Fedora window.  This is due to API-X following the transitive closure of imports and fetching ontologies from the registry.
    * This shows that the API-X demo has not focused on optimization; caching ontologies is low-hanging fruit and would reduce load on the repository and improve performance.  
    * This also shows that every extension is evaluated for binding on every request.  Even though the root repository resource has nothing to do with PCDM or PREMIS, API-X needs to test whether it can infer that a given resource can bind to any given extension.  The current implementation of API-X does this binding computation at runtime.  A possible optimization involves persisting extension binding results in a database for fast lookup.  See [implementations](https://github.com/fcrepo4-labs/fcrepo-api-x/blob/master/src/site/markdown/extension-definition-and-binding.md#implementations) for more information.

8. Take a look at one of the ontologies imported by PREMIS; for example <code>http://**localhost**/fcrepo/rest/apix/ontologies/id.loc.gov-vocabulary-preservation-cryptographicHashFunctions</code>.  It's mostly taxonomical classification of terms; useful for describing a vocabulary to people who may wish to use it for curation, but possibly less likely to be relevant for extension binding reasoning.  
  * Due to its extreme size, it should be apparent that including the entire closure of PREMIS for reasoning purposes will incur a cost with possibly little benefit.  This illustrates why a repository manager should be cognizant about the contents of the ontology registry, and should be careful about enabling automatic ontology persistence; or at least vet extensions and the ontologies they include before deploying them into the repository.
