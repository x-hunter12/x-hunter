#!/bin/bash
aa="\033[1;37m"
b="\033[1;36m"
r="\033[1;91m"
j="\033[0;33m"
suffix="\033[0m"
REPO="https://raw.githubusercontent.com/x-hunter12/x-hunter/main/"
function lane() {
echo -e "${b}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${suffix}"
}
fun_bar() {
    CMD[0]="$1"
    CMD[1]="$2"
    (
        [[ -e $HOME/fim ]] && rm $HOME/fim
        ${CMD[0]} -y >/dev/null 2>&1
        ${CMD[1]} -y >/dev/null 2>&1
        touch $HOME/fim
    ) >/dev/null 2>&1 &
    tput civis
    echo -ne "  ${j}Please Wait ${aa}- ${j}["
    while true; do
        for ((i = 0; i < 18; i++)); do
            echo -ne "\033[0;32m#"
            sleep 0.1s
        done
        [[ -e $HOME/fim ]] && rm $HOME/fim && break
        echo -e "${j}]"
        sleep 1s
        tput cuu1
        tput dl1
        echo -ne "  ${j}Please Wait Loading ${aa}- ${j}["
    done
    echo -e "${j}]${aa} -\033[1;32m Done !${aa}"
    tput cnorm
}
res1() {
wget -O sc.zip "${REPO}sc"
unzip sc.zip
chmod +x menu/*
mv menu/* /usr/local/sbin

wget -O alt.zip "${REPO}alt"
unzip alt.zip
chmod +x all-t/*
mv all-t/* /usr/bin

rm -fr /usr/sbin/xdxl
mkdir -p /usr/sbin/xdxl
mkdir -p /usr/sbin/xdxl/style
wget -O style.zip "${REPO}style.zip"
unzip style.zip
chmod +x style/*
mv style/* /usr/sbin/xdxl/style
}
function system(){
wget -q -O /etc/nginx/conf.d/xray.conf "https://github.com/zhets/project/raw/main/xray/xray.conf"
wget -q -O /etc/xray/config.json "https://github.com/zhets/project/raw/main/xray/config.json"
}
exe() {
rm -fr menu
rm -fr menu.zip
rm -fr up-x
rm -fr update.sh
rm -fr all-t
rm -fr alt.zip
rm -fr style
rm -fr style.zip
system
}
netfilter-persistent
clear
lane
echo -e " \e[1;97;101m             UPDATE SCRIPT              ${suffix}"
lane
echo -e ""
echo "  ${r} Downloading Files Update\033[1;37m"
fun_bar 'res1'
echo "  ${r} Remove Files \033[1;37m"
fun_bar 'exe'
lane
echo -e ""
read -n 1 -s -r -p "Press [ Enter ] to back on menu"
menu
