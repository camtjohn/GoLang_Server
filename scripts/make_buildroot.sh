#! /bin/bash

echo "Move server executible to buildroot rootfs. Run buildroot make."
mv /home/larry/Documents/Projects/Server/server /home/larry/buildroot/board/raspberrypi/rootfs_overlay/home/harry/

# Run make on buildroot
rm -rf output/target output/images
make -C /home/larry/buildroot/
