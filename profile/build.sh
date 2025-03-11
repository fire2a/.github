#!/bin/env bash

cd C2F-W/Cell2Fire
make clean
make
cd ../..

python3 -m venv venv --system-site-packages
. venv/bin/activate
cd fire2a-lib
pip install -r requirements.build.txt
pip install -r requirements.code.txt
pip install -r requirements.txt
pip install --editable .
cd ..

plugins_dir=~/.local/share/QGIS/QGIS3/profiles/default/python/plugins/
mkdir -p $plugins_dir
ln -sf "$(pwd)/toolbox/fireanalyticstoolbox" "$plugins_dir/fireanalyticstoolbox"
ln -sf "$(pwd)/C2F-W" toolbox/fireanalyticstoolbox/simulator/C2F
