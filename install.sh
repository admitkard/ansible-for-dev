#!/bin/bash

sudo apt install curl wget -y
# install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
sudo python get-pip.py
rm -rf get-pip.py

# install ansible
sudo python -m pip install ansible

# download ansible-repo
wget https://codeload.github.com/admitkard/ansible-for-dev/zip/refs/heads/master -O ansible-for-dev.zip
unzip -o ansible-for-dev.zip
rm -rf ansible-for-dev.zip
cd ansible-for-dev-master
chmod +x ./run.sh
./run.sh
