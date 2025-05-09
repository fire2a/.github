#!/bin/env bash
set -x

cd ~/C2F-W/Cell2Fire
make clean
make

rm -fr ~/venv
python3 -m venv ~/venv --system-site-packages
. ~/venv/bin/activate
cd ~/fire2a-lib
pip install -r requirements.build.txt
pip install -r requirements.code.txt
pip install -r requirements.txt
pip install --editable .

plugins_dir=~/.local/share/QGIS/QGIS3/profiles/default/python/plugins
mkdir -p $plugins_dir
ln -sf ~/toolbox/fireanalyticstoolbox $plugins_dir/fireanalyticstoolbox
ln -sf ~/C2F-W ~/toolbox/fireanalyticstoolbox/simulator/C2F
ln -sf ~/pan-europeo/pan_batido $plugins_dir/pan_batido
ln -sf ~/pan-europeo/panettone $plugins_dir/panettone
