#!/bin/bash

PI=4
JOBS=32
CONFIG=1

if [ "$CONFIG" == "1" ]; then
        echo "Configuring"
        if [ "$PI" == "3" ]; then
                KERNEL=kernel7
                make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
        else
                KERNEL=kernel7l
                make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2711_defconfig
        fi
fi

echo "Compiling"
make -j $JOBS ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs

if [ ! -d install ]; then
        mkdir -p install/boot/overlays
fi

echo "Installing modules"
env PATH=$PATH make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH=install modules_install

echo "Copying kernel"
cp arch/arm/boot/zImage install/boot/$KERNEL.img
cp arch/arm/boot/dts/*.dtb install/boot
cp arch/arm/boot/dts/overlays/*.dtb* install/boot/overlays/
cp arch/arm/boot/dts/overlays/README install/boot/overlays/

echo "Creating archive"
cd install
tar cvf ../kernel.tar --owner=root --group=root .
