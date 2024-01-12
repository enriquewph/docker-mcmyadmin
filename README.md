# docker-mcmyadmin

<p>
  <a href="https://github.com/enriquewph/docker-mcmyadmin/blob/main/LICENSE" alt="License">
    <img src="https://img.shields.io/github/license/enriquewph/docker-mcmyadmin" />
  </a>
  <img src="https://img.shields.io/github/languages/top/enriquewph/docker-mcmyadmin" />  
  <a href="https://hub.docker.com/r/enriquewph/docker-mcmyadmin" alt="DockerPulls">
    <img src="https://img.shields.io/docker/pulls/enriquewph/docker-mcmyadmin" />
  </a>
  <a href="https://hub.docker.com/r/enriquewph/docker-mcmyadmin/tags?page=1&ordering=last_updated" alt="DockerBuildStatus">
    <img src="https://img.shields.io/docker/image-size/enriquewph/docker-mcmyadmin/latest" />
  </a>
  <a href="https://github.com/enriquewph/docker-mcmyadmin/actions/workflows/build-and-publish.yml" alt="BuildStatus">
    <img alt="GitHub Workflow Status" src="https://img.shields.io/github/actions/workflow/status/enriquewph/docker-mcmyadmin/build-and-publish.yml">
  </a>
  <a href="https://github.com/enriquewph/docker-mcmyadmin/releases" alt="Releases">
    <img src="https://img.shields.io/github/v/release/enriquewph/docker-mcmyadmin" />
  </a>
  <a href="https://github.com/enriquewph/docker-mcmyadmin/releases" alt="Releases">
    <img alt="GitHub Release Date" src="https://img.shields.io/github/release-date/enriquewph/docker-mcmyadmin">
  </a>
  <a href="https://github.com/enriquewph/docker-mcmyadmin/commit" alt="Commit">
    <img alt="GitHub last commit" src="https://img.shields.io/github/last-commit/enriquewph/docker-mcmyadmin">
  </a>
</p>


> **Note:** This project is a fork from [tekgator/docker-mcmyadmin](https://github.com/tekgator/docker-mcmyadmin).

> **Changes in this fork:**
> - Switched from OPENJDK18 to [eclipse-temurin](https://hub.docker.com/_/eclipse-temurin) (OpenJDK v21)
> - Switched from [debian](https://www.debian.org/index.html) based image to a lightweight and more performance saver [alpine](https://www.alpinelinux.org/) one.




McMyAdmin Panel docker file to administrate and run all variants of a Java Minecraft Server.

- Maintained by [Patrick Weiss](https://github.com/enriquewph)
- Problems and issues can be filed on the [Github repository](https://github.com/enriquewph/docker-mcmyadmin/issues)

**Note:** As the below is overseen often, the default user/password for the McMyAdmin Login is **admin** / **pass123**

> ## McMyAdmin has been replaced by [AMP](https://cubecoders.com/AMP?utm_source=mcmyadmin)
> **Please use AMP for new installations.**
>
> **McMyAdmin was replaced by AMP in 2018, new users should use AMP instead of McMyAdmin. This page remains here for legacy users.**
>
> **AMP features the same ease of use and simple installation, but supports more games, has more features, and will continue to receive support and updates. McMyAdmin 2 is no longer receiving any feature updates.**
>
> **Please use [CubeCoders AMP](https://cubecoders.com/AMP?utm_source=mcmyadmin) for any new installations where possible.**

## Description

Goal of this docker image is to create an easy to use docker file providing the up to date McMyAdmin Panel which can run all kinds of Java Minecraft versions. 
Most images on Docker Hub do not save the world when stopping the container, which has been added to this image. The actual persistent data e.g. worlds, configuration, etc. is mounted to a volume so it can be configured easily.
Also this docker image tails the latest McMyAdmin log file to provide logging information e.g. [Portainer](https://www.portainer.io/) or on the command line.

## Details

* ~~Utilizing Debian 11 Bullseye slim version~~ Utilizing a lightweight and more performance saver [Alpine Linux](https://www.alpinelinux.org/)
* ~~OpenJDK-18 is used as it is required for some Minecraft plugins~~ [Eclipse Temurin](https://hub.docker.com/_/eclipse-temurin) (OpenJDK v21) is used as it provides better performance and security updates
* McMyAdmin Minecraft web based admin panel
* When the container stops firstly the world is saved and the server is properly shut down.
* The McMyAdmin Admin panel runs under minecraft user on port tcp/8080
* The actual Minecraft server runs on default port tcp/25565
* Maps a volume so you are free to make changes to configuration of McMyAdmin and Minecraft
* Includes GIT so the Spigot server jar can be build by McMyAdmin
* Java.Memory defaults to 2GB RAM / recommended are at least 2GB RAM within a docker container
* If you like to run the [Dynmap](https://dev.bukkit.org/projects/dynmap/files) or [Squaremap](https://hangar.papermc.io/jmp/squaremap) plugins just expose port tcp/8123 as well

## Run

Basic run command to get things up and running

```bash
docker run -d \
  --name mcmyadmin \
  -p 8080:8080 \
  -p 25565:25565 \
  --stop-timeout 30 \
  --restart unless-stopped \
  enriquewph/docker-mcmyadmin:latest
``` 

Map to local storage using an existing user on the host machine (get UID/GID via ID command)
```bash
-v /home/xxx/McMyAdmin:/data
-e PUID=xxx
-e PGID=xxx
``` 

Option to accept the Minecraft Server EULA automatically
```bash
-e EULA=1
``` 

Start and Re-start container automatically
```bash
--restart unless-stopped
``` 

Allow enough time when the container is stopped to shutdown Minecraft and McMyAdmin gracefully

```bash
--stop-timeout 30
``` 

If you like to expose other ports for some plugins e.g. [Dynmap](https://dev.bukkit.org/projects/dynmap/files)

```bash
-p 8123:8123 \
``` 

### Personal recommandation on how to use it

* Create a user on the host system e.g. minecraft via `useradd minecraft`
* Login with that user
* Create a directory for the game data in the home directory of this user via `mkdir ~/mcmyadmin`
* Obtain the UID and GID of that user via `id minecraft` e.g. UID 1000 / GID 100 
* Login to your admin user for creating the docker container

#### Use with docker run:
```bash
docker run -d \
  --name mcmyadmin \
  -p 8080:8080 \
  -p 25565:25565 \
  -v /home/minecraft/mcmyadmin:/data \
  -e PUID=1000 \
  -e PGID=100 \
  -e EULA=1 \
  --restart unless-stopped  \
  --stop-timeout 30 \
  enriquewph/docker-mcmyadmin:latest
``` 

#### Use with docker-compose:

A [sample](docker-compose.yml) docker-compose file can be found within the repository.

```yml
  mcmyadmin:
    image: enriquewph/docker-mcmyadmin:latest
    container_name: mcmyadmin
    environment:
      PUID: 1000
      PGID: 100
      EULA: 1
    volumes:
      - /home/minecraft/mcmyadmin:/data
    ports:
      - 8080:8080
      - 25565:25565
    stop_grace_period: 30s
    restart: unless-stopped
``` 

Now you have access to the Minecraft game data via the `minecraft` user on the host system by accessing `cd ~/mcmyadmin`

**HAVE FUN!**

## Next steps

1. Open McMyAdmin in your browser e.g. via http://localhost:8080
2. Login with 
    * User: **admin**
    * Password: **pass123**
3. Change the password!!!
4. Select the Minecraft version to run in the settings e.g. Vanilla, Spigot, etc. and press the install button (note Spigot build will take a while)
5. Configure your Minecraft server in the server settings
6. Click Start Server from Status tab (this will stop/restart a couple times, be patient)

## Optional but recommended steps

1. Stop the container
2. Open the file `McMyAdmin.conf` in your locale storage in an editor
3. Search for the line Java.Memory
4. Change to your needs, recommended is at least **2GB**
5. Start the container

## Adding Plugins or changing configuration of McMyAdmin / Minecraft

Within the mounted volume you can find:

* The `McMyAdmin.conf` file to configure the McMyAdmin Panel like Java RAM usage, etc.
* The `Minecraft` directory where you can find the `server.properties`, `logs`, etc.
* The `plugin` directory to add mods and change the configuration of mods

## Additional info

* Shell access whilst the container is running: `docker exec -it mcmyadmin /bin/bash`
* To monitor the logs of the container in realtime: `docker logs -f mcmyadmin`
