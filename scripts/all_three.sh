#! /bin/bash

# Build Go-lang app for RPi
./build_server.sh
./make_buildroot.sh
./write_to_sd.sh
