## Base Embedded

A baseline Docker container provisioned by our eght_app cookbook. If you do not already have Docker installed, refer [here](https://www.docker.com/community-edition).

## How does it work?

To get started, simply clone this repo:

```bash
> git clone git@git.8x8.com:ckeleher/Chefless.git
```

First, pull down any packages the project needs:

```bash
> cd base_embedded
> berks update
> berks vendor
> cd ..
```

Execute the commands below to build and run your container and to find its unique container ID:

```bash
# Building the container first with no caching is recommended
# if you are iterating on a previously built container.

> docker-compose build --no-cache
> docker-compose up -d
> docker ps
```

Make a note of the `CONTAINER_ID` of chefless_baseapp shown by `docker ps`. Once the container has finished running (`docker ps` will stop listing it when it finishes), run this next command to commit the container as an image with the name `baseapp`:

```bash
> docker commit CONTAINER_ID baseapp
```

You can now run and enter your container:

```bash
> docker run -it --entrypoint=sh baseapp
```
Note that any changes you make within your container will be lost when exiting it unless you commit the container again. This simply requires opening another terminal window, running `docker ps` to find the new `CONTAINER_ID`, and running the commit command like above.

## What else can I do with it?

Since this container is provisioned using eght\_app, you can customize it to your liking. The default setup targets the JDK artifact `dk-8u121-x64.tar.gz` and simply removes it. It also comes preconfigured with Jetty, Tomcat, and Jenkins users, as well as the Base user.

Simply put, anything that can be done with eght\_app is possible with this container set. More information on how to use eght\_app can be found [here](https://git.8x8.com/auto/chef/src/site-cookbooks).

## Why should I use this?

This setup provides the full ability to configure a container using eght\_app without having to install Chef or any of the systems that Chef needs. It accomplishes this by running distinct containers for Chef and its data and mounting their volumes within the app container, which allows our app container to access and run Chef without actually installing it. The end result is a much more lightweight container with minimal bloat.

## What do I do if something breaks?


Reach out to us on our mailing list, cloud-rad@8x8.com.

If you're running into a bug, please file an issue on our tracker.

## Current issues and limitations
* Freshly created containers will have an entrypoint command that does not work without the accompanying chef containers. This can be worked around by running the container with '--entrypoint=sh' and committing that new container over the original image, as described above.
* Containers are still somewhat large due to extra packages and features installed on CentOS containers. Optimizing for minimal container size is an ongoing proces.

## License

[Apache 2.0](LICENSE.md)