## acrepo Dockerfile

This image inherits from the [karaf image](../karaf/4.0.6), so its configuration and environment also hold for this image.  However, this image does have some modifications which facilitate the installation and execution of Amherst features.

The string "acrepo" is a short cut recognized as the Amherst feature repository at `mvn:edu.amherst.acdc/acrepo-karaf/LATEST/xml/features`.  At _image build time_, all of the latest features (typically SNAPSHOTs) found in the Amherst feature repository are installed into this Karaf image.

The acrepo image default debugging port is 5008.

If running on a `docker-machine`, remember to publish the ports to the [host](https://docs.docker.com/engine/reference/run/#/expose-incoming-ports).

### Environment variables and default values

* DEBUG_PORT=5008
* JAVA_DEBUG_PORT=${DEBUG_PORT}

This image inherits from the [karaf image](../karaf/4.0.6), so its environment is also available.
