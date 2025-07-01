#!/bin/bash

# the purpose of this script is to copy all the OAP files from the official image to /buildsrc
# because docker build can't fetch files from outside this directory

rm -rfv build

mkdir -p build/src
mkdir -p build/src/home/pi
mkdir -p build/src/usr/local/bin
mkdir -p build/src/usr/local/lib
mkdir -p build/src/etc
cp -r /home/pi/.openauto build/src/home/pi/.openauto
cp -r /usr/local/bin/autoapp build/src/usr/local/bin/autoapp
cp -r /usr/local/lib/libaasdk.so build/src/usr/local/lib/libaasdk.so
cp -r /usr/local/lib/libaasdk_proto.so build/src/usr/local/lib/libaasdk_proto.so
cp -r /etc/apt build/src/etc/apt

docker build -t oap-docker .