# Chefless

A baseline Docker container provisioned by our eght_app cookbook. This repo depends on [Docker](https://www.docker.com/community-edition) and the [Chef Development Kit](https://downloads.chef.io/chefdk).

## How does it work?

To get started, simply clone this repo:

```bash
> git clone git@git.8x8.com:ckeleher/Chefless.git
```

First, pull down any packages the project needs:

```bash
> cd base_embedded
> berks install
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

## How do I use this with my existing eght_app configs?

Using this repo with an existing eght\_app config is fairly simple. Copy the files listed below from the base\_embedded folder into your app config folder, then remove the base\_embedded folder and put your app config folder in its place.

* base\_embedded/Dockerfile
* base\_embedded/first-boot.json
* base\_embedded/zero.rb
* base\_embedded/chefclient/

Once you have these files copied over, you will need to find and replace appearances of "base_embedded" with the name of your application. These appear both in the top-level `Dockerfile` and `docker-compose.yml`, as well as in the files you just copied over. You will also need to replace the default role in `first-boot.json` with your app's role.

## Why should I use this?

This setup provides the full ability to configure a container using eght\_app without having to install Chef or any of the systems that Chef needs. This lets you create a more lightweight container with minimal bloat.

## Dependencies

*  [Docker](https://www.docker.com/community-edition)
*  [Chef Development Kit](https://downloads.chef.io/chefdk)

## What do I do if something breaks?


Reach out to us on our mailing list, cloud-rad@8x8.com.

If you're running into a bug, please file an issue on our tracker.

## Current issues and limitations
* Freshly created containers will have an entrypoint command that does not work without the accompanying chef containers. This can be worked around by running the container with `--entrypoint=sh` and committing that new container over the original image, as described above.
* Containers are still somewhat large due to extra packages and features installed on CentOS containers. Optimizing for minimal container size is an ongoing proces.

## License

[Apache 2.0](LICENSE.md)