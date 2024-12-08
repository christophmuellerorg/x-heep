#!/bin/bash

os=$(uname -s)
arch=$(uname -m)
echo Detected ${os}/${arch}

# tool versions to use
oss_cad_release_date=2024-09-28
verible_release_hash=v0.0-3862-g936dfb1d

# OSS CAD suite


if [ $os == "Linux" ]; then
    sed=sed
    if [ $arch == "arm64" ]; then
        oss_cad_release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${oss_cad_release_date}/oss-cad-suite-linux-arm64-${oss_cad_release_date//-/}.tgz
        verible_release=https://github.com/chipsalliance/verible/releases/download/${verible_release_hash}/verible-${verible_release_hash}-linux-static-arm64.tar.gz
    elif [ $arch == "x86_64" ]; then 
        oss_cad_release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${oss_cad_release_date}/oss-cad-suite-linux-x64-${oss_cad_release_date//-/}.tgz
        verible_release=https://github.com/chipsalliance/verible/releases/download/${verible_release_hash}/verible-${verible_release_hash}-linux-static-x86_64.tar.gz
    fi
elif [ $os  == "Darwin" ]; then
    sed=gsed
    if [ $arch == "arm64" ]; then
        oss_cad_release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${oss_cad_release_date}/oss-cad-suite-darwin-arm64-${oss_cad_release_date//-/}.tgz
    elif [ $arch == "x86_64" ]; then 
        oss_cad_release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${oss_cad_release_date}/oss-cad-suite-darwin-x64-${oss_cad_release_date//-/}.tgz
    fi 
    verible_release=https://github.com/chipsalliance/verible/releases/download/${verible_release_hash}/verible-${verible_release_hash}-macOS.tar.gz
fi

echo Downloading $oss_cad_release
wget $oss_cad_release -O oss-cad-suite.tgz
mkdir -p tools
tar -xzvf oss-cad-suite.tgz -C tools

echo Downloading $verible_release
wget $verible_release -O verible.tgz
# we are installing the static verible binaries into the oss cad folder
tar -xzvf verible.tgz -C tools/oss-cad-suite verible-${verible_release_hash}/bin/ --strip-components=1

echo Adding X-Heep requirements into the OSS cad suite python venv
source tools/oss-cad-suite/environment
tabbypy3 -m pip install -r python-requirements.txt

# rebrand to make sure our users do not mix up different environments...
$sed -i 's/OSS CAD Suite/XHEEP OSS CAD Suite/g' tools/oss-cad-suite/environment

# fixing "VERILATOR_ROOT is inconsistent" error 
$sed -i 's/export VERILATOR_ROOT/# export VERILATOR_ROOT/g' tools/oss-cad-suite/environment

# this should be fixed in the makefile, eventually..
echo 'export CONDA_DEFAULT_ENV="ALL THE TOOLS ARE IN THE PATH"' >> tools/oss-cad-suite/environment
