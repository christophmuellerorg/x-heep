#!/bin/sh

os=$(uname -s)
arch=$(uname -m)
release_date=2024-09-28
release_date_nodash=$(echo $release_date | sed s/-//g)

# Default: Linux/x64
release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${release_date}/oss-cad-suite-linux-x64-${release_date_nodassh}.tgz

if [ $os  =~ ^Linux ]; then
    if [ $arch =~ ^arm64 ]; then
        release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${release_date}/oss-cad-suite-linux-arm64-${release_date_nodassh}.tgz
    fi
elif [ $os  =~ ^Darwin ]; then
    if [ $arch =~ ^arm64 ]; then
        release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${release_date}/oss-cad-suite-darwin-arm64-${release_date_nodassh}.tgz
    elif [ $arch =~ ^x86_64 ]; then 
        release=https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${release_date}/oss-cad-suite-darwin-x64-${release_date_nodassh}.tgz
    fi 
fi

echo Detected ${os}/${arch}
echo Downloading $release

wget $release -O oss-cad-suite.tgz
mkdir -p tools
tar -xzvf oss-cad-suite.tgz -C tools