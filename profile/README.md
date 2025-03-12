# Index
1. [About Fire2a](#about-fire2a)
2. [Getting help](#getting-help)
3. [Contributing](#contributing)
4. [Developer setup](#developer-setup)
   - [Container](#container)
   - [Manual](#manual)
   
# About Fire2a
_We are a team dedicated to finding scientific and technological solutions to mitigate the effects of wildfires. We believe open-source collaboration is key and also providing custom consulting services for real-world organizations. [Contact us](mailto:fire2a@fire2a.com)_

_Our solutions involve the development of novel methodologies through the integration of various mathematical and technological tools. These tools include machine learning for fire ignition modeling, spatially explicit wildfire simulators, fire risk metrics, species distribution models, stochastic and multiobjective optimization, and simulation-based optimization._

_Our goal is create fire-resilient landscapes while minimizing potential carbon emissions, protecting wildlife biodiversity, and ensuring the safety of human communities._

## Main repos overview:

__1. [Cell2FireW](https://github.com/fire2a/C2F-W):__  C++ command line WildFire simulator ([forked](https://github.com/Cell2Fire))

__2. [Fire-Analytics-ToolBox](https://github.com/fire2a/fire-analytics-qgis-processing-toolbox-plugin):__ Friendly [QGIS](https://qgis.org/) Processing Toolbox Plugin, interfacing our tools (simulation, optimization, GIS tasks and algorithm, etc.) in various ways, including easy to use clickable dialogs.

__3. [Algorithms-libs](https://github.com/fire2a/fire2a-lib):__ [Python package](https://pypi.org/project/fire2a-lib/) with algorithms and common GIS tasks.

__4. [Documentation](https://github.com/fire2a/docs):__ End user documentation, including Cell2Fire, Qgis-Toolbox, QGIS recipes, install & plugin management. [Check it here](https://fire2a.github.io/docs/)

# Getting help
- [Outreach contact](mailto:fire2a@fire2a.com)
- [Discord channel](https://discord.gg/wSuSFjrt)
- [Getting help tutorial/checklist](https://fire2a.github.io/docs/getting-help/)

# Contributing
All contibutions are welcome, for effectiveness please follow:
- [Git etiquette](https://github.com/naming-convention/naming-convention-guides/tree/master/git) 
- [Coding style](https://github.com/fire2a/fire2a-lib/blob/main/CODING.md)
- Code formatting (each repo has it's own configuration... [clang-format](https://github.com/fire2a/C2F-W/blob/main/CODING.md), [black+friends](https://github.com/fire2a/fire2a-lib/blob/a82260e3d4b3cc0825bf81cd4331f1c9372b2351/pyproject.toml#L83))
- Issues and Pull Requests minimal consistency:
   1. Check [getting help](https://fire2a.github.io/docs/getting-help/) before posting an issue
   1. Pull Requests must be associated to a corresponding issue that explains the motivation for the change and the expected outcome.
   2. Add a comment with an overview of the changes made
   3. One feature/bugfix per pull request
- Scientific citations: _Fire research deals with real life or death risks;_ If your code involves scientific models or calculations, include citations in [BibText format](https://www.bibtex.com/g/bibtex-format/). More info  [Cell2Fire-W/docs/README.md](https://github.com/fire2a/C2F-W/blob/main/docs/README.md)

# Developer setup
Pick your poison:
- Containerized, building on top of the [official QGIS container](https://hub.docker.com/r/qgis/qgis)
- Or manual, system-wide installing QGIS and using it through a python virtual environment

## Container
[Long tutorial](../README.md)
TL;DR:
1. Clone the repos: [Cell2FireW](https://github.com/fire2a/C2F-W), [Fire-Analytics-ToolBox](https://github.com/fire2a/fire-analytics-qgis-processing-toolbox-plugin), [Algorithms-libs](https://github.com/fire2a/fire2a-lib)
2. Get ![Containerfile](../Containerfile) and ![build.sh](../build.sh); Build the image (that mounts the repos and runs the build script).
3. Run the container, enable our plugin in QGIS. 
```bash
# required packages podman & git
sudo apt install podman git wget

# the current directory will be shared to the container
# let's start with an empty one
mkdir fire2a
cd fire2a

# get Containerfile and build.sh
wget https://raw.githubusercontent.com/fire2a/.github/refs/heads/main/build.sh
wget https://raw.githubusercontent.com/fire2a/.github/refs/heads/main/Containerfile

# clone the repos
git clone git@github.com:fire2a/C2F-W.git
git clone git@github.com:fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
git clone git@github.com:fire2a/fire2a-lib.git

# build the container mounting the current directory into container user's home (/root)
podman build --tag qgis-fire2a --volume $(pwd):/root .

# run the container also with display capabilities
podman run -it --env DISPLAY=$DISPLAY --volume /tmp/.X11-unix:/tmp/.X11-unix --volume $(pwd):/root --device /dev/dri --name fire2a qgis-fire2a

# re-run the container
podman start fire2a
podman stop fire2a
```
Keep in mind that any changes made to the container's filesystem are lost when stopped except those made into the user's home (`/root`).
This includes all temporary generated layers (whose files are generated into /tmp/processing...), so to keep them, save them home (`--volume $(pwd):/root`).

## Manual
1. Install the latest QGIS
2. Clone the repos
3. Symbolic link them
4. Run QGIS
### 1. Get latest qgis  
- steps from https://qgis.org/resources/installation-guide/#debianubuntu  
- check your distro version `$lsb_release -a`, below is for Debian 12 (bookworm)  
```bash
# required packages
sudo apt install gnupg software-properties-common wget

# add the key
sudo wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg

# add the repo to sources.list (is the suite still bookworm?)
echo 'Types: deb deb-src
URIs: https://qgis.org/debian
Suites: bookworm
Architectures: amd64
Components: main
Signed-By: /etc/apt/keyrings/qgis-archive-keyring.gpg' | sudo tee /etc/apt/sources.list.d/qgis.sources

# install
sudo apt update
sudo apt install qgis qgis-plugin-grass
```
### 2. Get Cell2Fire, python libs and QGIS toolboox-plugin
```bash
# choose install location, below ~/fire is used
fire=~/fire
mkdir -p "$fire"

# get Cell2FireW
cd "$fire"
git clone git@github.com:fire2a/C2F-W.git
sudo apt install g++-12 libboost-all-dev libeigen3-dev libtiff-dev
cd C2F-W/Cell2Fire
make clean
make

# get python library
cd "$fire"
sudo apt install python3-venv 
python3 -m venv venv --system-site-packages # needs system qgis packages
source "$fire/venv/bin/activate"
git clone git@github.com:fire2a/fire2a-lib.git lib
cd lib
pip install -r requirements.build.txt
pip install -r requirements.code.txt
pip install -r requirements.txt
pip install --editable .

# get toolbox
cd "$fire"
git clone git@github.com:fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
```
### 3. symlink them
```bash
plugins_dir=~/.local/share/QGIS/QGIS3/profiles/default/python/plugins/

 # if never opened QGIS
mkdir -p $plugins_dir

# toolbox to QGIS plugins
ln -sf "$(fire)/toolbox/fireanalyticstoolbox" "$plugins_dir/fireanalyticstoolbox"

# C2F to toolbox
ln -sf "$(fire)/C2F-W" "$(fire)/toolbox/fireanalyticstoolbox/simulator/C2F"
```
### 4. run
```bash
source $fire/venv/bin/activate
qgis
```
Enable our plugin on Plugins>Manage..>Installed> enable the check box on 'FireFire Analytics Processing-Toolbox' 

[Official tutorial](https://docs.qgis.org/3.4/en/docs/training_manual/qgis_plugins/fetching_plugins.html)
