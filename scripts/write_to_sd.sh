#! /bin/bash

# Transfer to SD Card
echo "Write to SD Card."
sudo dd if=/home/larry/buildroot/output/images/sdcard.img of=/dev/mmcblk0 bs=1M status=progress
sync
