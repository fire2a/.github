# Index
1. [About Fire2a](#about-fire2a)
2. [Getting help](#getting-help)
3. [Contributing](#contributing)
4. [Developer setup](#developer-setup)
    1. [Get latest qgis](#1-get-latest-qgis)
    2. [Get Cell2Fire, python libs and QGIS toolboox-plugin](#2-get-cell2fire-python-libs-and-qgis-toolboox-plugin)
    3. [symlink them](#3-symlink-them)
    4. [run](#4-run) 
# About Fire2a
_We are a team dedicated to finding scientific and technological solutions to mitigate the effects of wildfires. We believe open-source collaboration is key and also providing custom consulting services for real-world organizations. [Contact us](mailto:fire2a@fire2a.com)_

_Our solutions involve the development of novel methodologies through the integration of various mathematical and technological tools. These tools include machine learning for fire ignition modeling, spatially explicit wildfire simulators, fire risk metrics, species distribution models, stochastic and multiobjective optimization, and simulation-based optimization._

_Our goal is create fire-resilient landscapes while minimizing potential carbon emissions, protecting wildlife biodiversity, and ensuring the safety of human communities._

## Main repos overview:

__1. [Cell2FireW](https://github.com/fire2a/C2F-W):__  C++ command line WildFire simulator ([forked](https://github.com/Cell2Fire))

__2. [Fire-Analytics-ToolBox](https://github.com/fire2a/fire-analytics-qgis-processing-toolbox-plugin):__ Friendly [QGIS](https://qgis.org/) Processing Toolbox Plugin, interfacing our tools (simulation, optimization, GIS tasks and algorithm, etc.) in various ways, including easy to use clickable dialogs.

__3. [Algorithms-libs](https://github.com/fire2a/fire2a-lib):__ [Python package](https://pypi.org/project/fire2a-lib/) with algorithms and common GIS tasks.

__4. [Documentation](https://github.com/fire2a/docs):__ User documentation, including QGIS recipes, install & plugin management.

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
   4. If your code involves scientific calculations, include proper citations. Follow the documentation guidelines in `docs/README.md` to reference sources correctly.

# Developer setup
1. get QGIS
2. get the repos
3. symlink them
4. run
## 1. Get latest qgis  
- steps from https://qgis.org/resources/installation-guide/#debianubuntu  
- check your distro version `$lsb_release -a`, below is for Debian 12 (bookworm)  
```bash
sudo apt install gnupg software-properties-common
sudo mkdir -m755 -p /etc/apt/keyrings  # not needed since apt version 2.4.0 like Debian 12 and Ubuntu 22 or newer
sudo wget -O /etc/apt/keyrings/qgis-archive-keyring.gpg https://download.qgis.org/downloads/qgis-archive-keyring.gpg
# is the suite bookworm ?
echo 'Types: deb deb-src
URIs: https://qgis.org/debian
Suites: bookworm
Architectures: amd64
Components: main
Signed-By: /etc/apt/keyrings/qgis-archive-keyring.gpg' | sudo tee /etc/apt/sources.list.d/qgis.sources
sudo apt update
sudo apt install qgis qgis-plugin-grass
```
## 2. Get Cell2Fire, python libs and QGIS toolboox-plugin
```bash
# choose install location
fire=~/fire
mkdir -p $fire

# get cell2fireW
cd $fire
git clone git@github.com:fire2a/C2F-W.git C2F
sudo apt install g++-12 libboost-all-dev libeigen3-dev libtiff-dev
cd C2F/Cell2Fire
make

# get python library
cd $fire
sudo apt install python3-venv 
python3 -m venv venv --system-site-packages # needs system qgis packages
source $fire/venv/bin/activate
git clone git@github.com:fire2a/fire2a-lib.git lib
cd lib
pip install -r requirements.build.txt
pip install -r requirements.code.txt
pip install -r requirements.txt
pip install --editable .

# get toolbox
cd $fire
git clone git@github.com:fire2a/fire-analytics-qgis-processing-toolbox-plugin.git toolbox
```

# 3. symlink them
```bash
# toolbox to QGIS plugins
mkdir -p ~/.local/share/QGIS/QGIS3/profiles/default/python/plugins/
cd ~/.local/share/QGIS/QGIS3/profiles/default/python/plugins/
ln -s $fire/toolbox/fireanalyticstoolbox .

# c2f to toolbox
cd $fire/toolbox/fireanalyticstoolbox/simulator
ln -s $fire/C2F .
```
# 4. run
```bash
source $fire/venv/bin/activate
qgis
# install the toolbox plugin https://docs.qgis.org/3.4/en/docs/training_manual/qgis_plugins/fetching_plugins.html
```
