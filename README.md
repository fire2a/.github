# QGIS container with Fire2A plugins

This container builds on top of the latest container version of QGIS with all of our tools built, installed and configured (see `Containerfile` and `build.sh` for details)
The container is compatible with both Podman and Docker. We recommend using Podman, but replacing podman with docker should work.
All you got to do is get the repos in the right place, build the container and run it!

The right place is `qgis-vol` directory that'll be mounted on the Container.
- Remember that everything except files in this directory will be lost when the container is deleted/stopped, .e.g., temporary outputs of processing runs.
- A symbolic link to the `qgis-vol` directory will not work when running the container, so you have to copy the files into the directory (or move `build.sh` and `Container` properly).

## TL;DR

```bash
sudo apt install podman git

mkdir qgis-vol
cd qgis-vol

git clone git@github.com:fire2a/C2F-W.git
git clone git@github.com:fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
git clone git@github.com:fire2a/fire2a-lib.git
git clone git@github.com:fire2a/qgis-pan-europeo.git

# build the container "qgis-fire2a" image
podman build -t qgis-fire2a --volume $(pwd)/qgis-vol:/root -f Containerfile .

# run the "fire2a" container
podman run -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --volume qgis-vol:/root --device /dev/dri --name fire2a qgis-fire2a

# enable our plugin on QGIS plugin manager. usually fails and needs a QGIS restart
# see https://fire2a.github.io/docs/qgis-management/plugins.html#dissapeared-plugin

# restart the container
podman start qgis-fire2a
```

## Prerequisites

```bash
sudo apt install podman git
```

Ensure you have Podman installed on your system. You can find installation instructions in the [official Podman documentation](https://podman.io/docs/installation).
You must also have Git installed.

## Clone the repositories

Clone our tools into a dedicated directory.
```bash
mkdir qgis-vol
cd qgis-vol
git clone git@github.com:fire2a/qgis-pan-europeo.git
git clone git@github.com:fire2a/fire2a-lib.git
git clone https://github.com/fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
git clone https://github.com/fire2a/C2F-W.git
```

## Build the image

To build the container image using Podman, navigate to the directory where the container file is stored
and run the following command:

```bash
podman build -t qgis-fire2a --volume Path/to/qgis-vol:/root -f Containerfile .
```

This will build the container using a volume mount, sharing all that is in your local directory `qgis-vol` to the
directory `/root` in the container.

## Run the container

Once the image is built, you can run QGIS using Podman:

```bash
podman run -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --volume ~/Path/to/qgis-vol:/root --device /dev/dri --name qgis-fire2a qgis-fire2a
```
You can use the QGIS application as you would normally. Everything you save onto the container directory `root` will
be saved to your local directory `qgis-vol`. **If you do not save your project to this directory, it will be lost when
you close the application or the container**.

To access the container's terminal while you're running QGIS, open another local terminal and run
```bash
podman exec -it qgis-fire2a bash
```

To open the same container again do
```bash
podman start qgis-fire2a
```
