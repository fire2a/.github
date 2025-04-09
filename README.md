# QGIS container with Fire2A plugins
The container runs the latest version of QGIS with all of our tools without having to manually build and configure the
application on your system. The container is compatible with both Podman and Docker. We recommend using Podman, but the
instructions found here are easily translated into Docker.
### Everything that is not saved to the container directory `/mnt` will be lost once the container stops running.
## TL;DR Linux

```bash
sudo apt install podman git
mkdir qgis-vol
cd qgis-vol
git clone git@github.com:fire2a/qgis-pan-europeo.git
git clone git@github.com:fire2a/fire2a-lib.git
git clone https://github.com/fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
git clone https://github.com/fire2a/C2F-W.git
# build the container
podman build -t qgis-fire2a --volume $(pwd)/qgis-vol:/mnt -f Containerfile .
# run the container
podman run -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --volume qgis-vol:/mnt --device /dev/dri --name fire2a qgis-fire2a
# be sure to save your qgis project in the mnt directory so you can access it later, otherwise it will be lost forever
```

## Prerequisites
### Linux

Ensure you have Podman installed on your system. You can find installation instructions in the [official Podman documentation](https://podman.io/docs/installation).
You must also have Git installed.

```bash
sudo apt install podman git
```
### MacOS
```bash
brew install --cask docker
# Install XQuartz for GUI forwarding
brew install --cask xquartz
brew install --cask git
```
Reboot your machine to complete the setup.

#### XQuartz Configuration

- Launch XQuartz from Applications.

- Open Preferences → Security tab.

- Check: "Allow connections from network clients"

- Quit and restart XQuartz.

- In your terminal, run: `xhost +localhost`

This allows Docker containers to forward GUI windows to your macOS desktop.


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
podman build -t qgis-fire2a --volume Path/to/qgis-vol:/mnt .
```

This will build the container using a volume mount, sharing all that is in your local directory `qgis-vol` to the
directory `/mnt` in the container.

If you're using Docker:
```bash
docker build -t qgis-fire2a -f Containerfile .
```

## Run the container

Once the image is built, you can run QGIS:

**Podman**
```bash
podman run -it \
  --env DISPLAY=$DISPLAY \
  --device /dev/dri \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --volume ~/Path/to/qgis-vol:/mnt \
  --name fire2a \
  qgis-fire2a
```
**Docker**
```bash
docker run -it \
  --env DISPLAY=host.docker.internal:0 \
  --volume /tmp/.X11-unix:/tmp/.X11-unix \
  --volume ~/Path/to/qgis-vol:/mnt \
  --name fire2a \
  qgis-fire2a
```
You can use the QGIS application as you would normally. Everything you save onto the container directory `mnt` will
be saved to your local directory `qgis-vol`. **If you do not save your project to this directory, it will be lost when
you close the application or the container**.

To access the container's terminal while you're running QGIS, open another local terminal and run
```bash
podman exec -it qgis-fire2a bash
```
### Remember that everything that is not saved to the container directory `/mnt` will be lost once the container stops running.

