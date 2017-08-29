## karaf 4.0.9 Dockerfile

This image builds on the [Karaf 4.0.9 docker image](../4.0.9/README.md) by
installing Camel and ActiveMQ features.  This is a mechanism that saves
comsiderable space, as Camel and ActiveMQ are larged.  To the extent that
images are built off this one, the space consumed by Camel and ActiveMQ will
be shared between all images.
