#! /bin/bash

echo "Erasing old SSH session keys, starting anew..."

ssh-keygen -f '/home/larry/.ssh/known_hosts' -R '192.168.0.112'

ssh harry@192.168.0.112

