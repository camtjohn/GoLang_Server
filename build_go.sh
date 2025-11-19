#! /bin/bash

echo "Build GO executable for RPI"

# Build for RPi. Move executable to buildroot overlay
cd /home/larry/Documents/Projects/Server/
GOARCH=arm GOARM=6 CGO_ENABLED=0 go build
