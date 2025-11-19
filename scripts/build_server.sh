#! /bin/bash

# Build Go-lang app for RPi
echo "Build GO executable for RPI. Run buildroot make. Write to SD Card."
cd /home/larry/Documents/Projects/Server/
GOARCH=arm GOARM=6 CGO_ENABLED=0 go build
