#!/bin/bash
REPO2="https://github.com/x-hunter12/x-hunter/raw/main/"

function downloadingsc() {
cd
wget -q -O sc.zip "${REPO2}sc"
unzip sc.zip
chmod +x menu/*
mv menu/* /usr/local/sbin

wget -q -O alt.zip "${REPO2}alt"
unzip alt.zip
chmod +x all-t/*
mv all-t/* /usr/bin

rm -fr /usr/sbin/xdxl
mkdir -p /usr/sbin/xdxl
mkdir -p /usr/sbin/xdxl/style
wget -q -O style.zip "${REPO2}y"
unzip style.zip
chmod +x style/*
mv style/* /usr/sbin/xdxl/style

mkdir /usr/bin/xdxl
wget -q -O .bashrc.1 "${REPO2}bash/.bashrc.1"
chmod +x .bashrc.1
mv .bashrc.1 /usr/bin/xdxl
}
function removesc() {
rm -fr menu
rm -fr menu.zip
rm -fr up-x
rm -fr update.sh
rm -fr all-t
rm -fr alt.zip
rm -fr style
rm -fr style.zip
}
function updatesc() {
downloadingsc
removesc
}
updatesc
clear
rm -fr xd.sh
echo -e ""
echo -e ""
clear
menu
