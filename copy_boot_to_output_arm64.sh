#!/bin/bash

echo "start build outputs --> output/ directory"
rm -rf output/
mkdir output
mkdir output/overlays

echo "copy start ...."
cp arch/arm64/boot/Image output/
cp arch/arm64/boot/dts/broadcom/*.dtb output/
cp arch/arm64/boot/dts/overlays/*.dtb* output/overlays/
cp arch/arm64/boot/dts/overlays/README output/overlays/
echo "copy end ...."

echo "copy modules start..."
sudo rm -rf mnt/
mkdir mnt/
mkdir mnt/fat32
mkdir mnt/ext4
sudo env PATH=$PATH make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- INSTALL_MOD_PATH=mnt/ext4 modules_install
echo "copy modules end..."

echo "compress mnt/ start..."
tar -zcvf mnt.tar.gz mnt
echo "compress mnt/ end..."
