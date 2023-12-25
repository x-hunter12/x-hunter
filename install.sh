#!/bin/bash
apt update -y
apt upgrade -y
wget -q https://raw.githubusercontent.com/x-hunter12/x-hunter/main/install-x.sh
chmod +x install-x.sh
./install-x.sh
