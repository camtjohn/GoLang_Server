#! /bin/bash

echo "Build GO executable for RPI. Run buildroot make. Write to SD Card."

# temp test go program: start url stream
export GOARCH=arm 
export GOARM=6 
export GOOS=linux

# Buildroot toolchain compiler
#export CC=~/buildroot/output/host/bin/arm-linux-gnueabi-gcc
export CC=arm-linux-gnueabi-gcc

# Sysroot includes and libs
export SYSROOT=~/buildroot/output/staging

export CGO_CFLAGS="--sysroot=$SYSROOT -I$SYSROOT/usr/include"
export CGO_LDFLAGS="--sysroot=$SYSROOT -L$SYSROOT/usr/lib -lvlc"

export CGO_ENABLED=1
go build -o stream

mv stream /home/larry/buildroot/board/raspberrypi/rootfs_overlay/usr/bin/

# Log time of this make execution
echo "$(date)" > ~/buildroot/board/raspberrypi/rootfs_overlay/home/harry/log_builds.txt

# Run make on buildroot
make -C /home/larry/buildroot/

# Transfer to SD Card
sudo dd if=/home/larry/buildroot/output/images/sdcard.img of=/dev/mmcblk0 bs=1M status=progress
sync
