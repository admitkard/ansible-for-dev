#!/bin/bash

sudo apt install ansible wget
wget https://github.com/admitkard/ansible-for-dev/archive/refs/heads/master.zip -O ansible-for-dev.zip
unzip ansible-for-dev.zip
cd ansible-for-dev-master
./run.sh
