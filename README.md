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

You can now build your container. You should also use the `--no-cache` flag for `docker-compose up` if you are iterating upon a previously built container. Execute the commands below to build and run your container and to find its unique container ID:

```bash
> docker-compose up -d --build
> docker ps
```

Make a note of the container ID of nochef_baseapp shown by `docker ps`. Once the container has finished running (`docker ps` will stop listing it when it finishes), run this next command to commit the container as an image:

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

Simply put, anything that can be done with eght\_app is possible to do within this container. More information on how to use eght\_app can be found [here](https://git.8x8.com/auto/chef/src/site-cookbooks).

## Why should I use this?

This setup provides the full ability to configure a container using eght\_app without having to install Chef or any of the systems that Chef needs. It accomplishes this by running distinct containers for Chef and its data and mounting their volumes within the app container, which allows our app container to access and run Chef without actually installing it. The end result is a much more lightweight container with minimal bloat.

## What do I do if something breaks?


Reach out to us on our mailing list, cloud-rad@8x8.com.

If you're running into a bug, please file an issue on our tracker.

## Current issues and limitations
* Paths for roles, data_bags, and environments are hardcoded in `base_embedded/zero.rb`.
* Containers are still somewhat large due to extra packages and features installed on CentOS containers.

## License

[Apache 2.0](LICENSE.md)