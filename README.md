docker-owncloud
===============

The necessary tools to build a docker image of owncloud

## TODO list

* include download of owncloud source code during in the Dockerfile 
* generate the key/certificate on the fly (first run of the image)
* allow the definition of common name and other certificate attributes (probably via env vars / -e)
* remove the owncloud source code from the repository (download it via wget during build time)
