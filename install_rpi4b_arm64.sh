#!/bin/bash

if [ $# -ne 1 ]; then
        echo "usage: $0 <target dir>"
        exit -1
fi
echo "+++++++++++++++++++++++++++"
echo "+++++++ $0 start... +++++++"
echo "+++++++++++++++++++++++++++"

echo "extract $1/mnt.tar.gz start..."
sudo tar -zxvf ./$1/mnt.tar.gz -C ./$1/
echo "extract mnt.tar.gz end..."

echo "modules install start..."
sudo cp -rf ./$1/mnt/ext4/lib/modules/6.1.61-v8+ /lib/modules/
echo "modules install end..."

echo "kernel image install start..."
sudo cp $1/output/Image /boot/firmware/kernel8.img
echo "kernel image install end..."

echo "dtb, dtbo, README install start..."
sudo cp $1/output/*.dtb /boot/firmware/
sudo cp $1/output/overlays/*.dtb* /boot/firmware/overlays/
sudo cp $1/output/overlays/README /boot/firmware/overlays/
echo "dtb, dtbo, README install end..."

echo "+++++++++++++++++++++++++++"
echo "+++++++++++ END +++++++++++"
echo "+++++++++++++++++++++++++++"
