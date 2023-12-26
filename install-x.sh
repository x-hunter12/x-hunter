#!/bin/bash
clear
rm -fr install-x.sh
Green="\e[92;1m"
RED="\033[31m"
YELLOW="\033[33m"
BLUE="\033[36m"
FONT="\033[0m"
GREENBG="\033[42;37m"
REDBG="\033[41;37m"
OK="${Green}--->${FONT}"
ERROR="${RED}[ERROR]${FONT}"
GRAY="\e[1;30m"
NC='\e[0m'
r='\e[1;31m'
g="\033[1;92m"
green='\e[0;32m'
export IP=$(curl -sS ipv4.icanhazip.com)

url_izin="https://raw.githubusercontent.com/zhets/izinsc/main/ip"
data_server=$(curl -v --insecure --silent https://google.com/ 2>&1 | grep Date | sed -e 's/< Date: //')
date_list=$(date +"%Y-%m-%d" -d "$data_server")
checking_sc() {
  useexp=$(wget -qO- $url_izin | grep $IP | awk '{print $3}')
  if [[ $date_list < $useexp ]]; then
echo -ne
  else
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -e "\033[42m          404 NOT FOUND AUTOSCRIPT          \033[0m"
echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
echo -e ""
    echo -e "            ${RED}PERMISSION DENIED !${NC}"
    echo -e "   \033[0;33mYour VPS${NC} $IP \033[0;33mHas been Banned${NC}"
    echo -e "     \033[0;33mBuy access permissions for scripts${NC}"
    echo -e "             \033[0;33mContact Admin :${NC}"
    echo -e "      \033[0;36mWhatsapp${NC} wa.me/6283160098834"
    echo -e "\033[1;93m────────────────────────────────────────────\033[0m"
    exit
  fi
}
checking_sc
# // Checking Os Architecture
if [[ $( uname -m | awk '{print $1}' ) == "x86_64" ]]; then
echo -e "${OK} Your Architecture Is Supported ( ${green}$( uname -m )${NC} )"
else
echo -e "${EROR} Your Architecture Is Not Supported ( ${YELLOW}$( uname -m )${NC} )"
exit 1
fi

# // Checking System
if [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "ubuntu" ]]; then
echo -e "${OK} Your OS Is Supported ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
elif [[ $( cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g' ) == "debian" ]]; then
echo -e "${OK} Your OS Is Supported ( ${green}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
else
echo -e "${EROR} Your OS Is Not Supported ( ${YELLOW}$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g' )${NC} )"
exit 1
fi

if [ "${EUID}" -ne 0 ]; then
		echo "You need to run this script as root"
		exit 1
fi
if [ "$(systemd-detect-virt)" == "openvz" ]; then
		echo "OpenVZ is not supported"
		exit 1
fi
red='\e[1;31m'
green='\e[0;32m'
NC='\e[0m'
clear

# REPO
REPO="https://raw.githubusercontent.com/zhets/project/main/"

# Information vps
curl -sS "ipinfo.io/org?token=7a814b6263b02c" > /root/.isp
curl -sS "ipinfo.io/city?token=7a814b6263b02c" > /root/.city
curl -sS "ipinfo.io/timezone?token=7a814b6263b02c" > /root/.timezone

####
start=$(date +%s)
secs_to_human() {
echo "Installation time : $((${1} / 3600)) hours $(((${1} / 60) % 60)) minute's $((${1} % 60)) seconds"
}
function print_ok() {
echo -e "${OK} ${BLUE} $1 ${FONT}"
}
function print_install() {
echo -e "${g} ┌──────────────────────────────────────────┐${NC}"
echo -e "${g} │${NC} $1 "
echo -e "${g} └──────────────────────────────────────────┘${NC}"
sleep 2
}

function print_error() {
echo -e "${ERROR} ${REDBG} $1 ${FONT}"
}

function print_success() {
if [[ 0 -eq $? ]]; then
echo -e "${g} ┌──────────────────────────────────────────┐${NC}"
echo -e "${g} │${NC} $1 berhasil dipasang"
echo -e "${g} └──────────────────────────────────────────┘${NC}"
sleep 2
fi

}
function is_root() {
if [[ 0 == "$UID" ]]; then
print_ok "Root user Start installation process"
else
print_error "The current user is not the root user, please switch to the root user and run the script again"
fi

}

# Buat direktori xray
print_install "Membuat direktori xray"
mkdir -p /etc/xray

curl -s ipinfo.io/city >> /etc/xray/city
curl -s ifconfig.me > /etc/xray/ipvps
curl -s ipinfo.io/org | cut -d " " -f 2-10 >> /etc/xray/isp
touch /etc/xray/domain
mkdir -p /var/log/xray
chown www-data.www-data /var/log/xray
chmod +x /var/log/xray
touch /var/log/xray/access.log
touch /var/log/xray/error.log
mkdir -p /var/lib/fvstore >/dev/null 2>&1
# // Ram Information
while IFS=":" read -r a b; do
case $a in
"MemTotal") ((mem_used+=${b/kB})); mem_total="${b/kB}" ;;
"Shmem") ((mem_used+=${b/kB}))  ;;
"MemFree" | "Buffers" | "Cached" | "SReclaimable")
mem_used="$((mem_used-=${b/kB}))"
;;
esac
done < /proc/meminfo
Ram_Usage="$((mem_used / 1024))"
Ram_Total="$((mem_total / 1024))"
export tanggal=`date -d "0 days" +"%d-%m-%Y - %X" `
export OS_Name=$( cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/PRETTY_NAME//g' | sed 's/=//g' | sed 's/"//g' )
export Kernel=$( uname -r )
export Arch=$( uname -m )

# Change Environment System
function first_setup(){
timedatectl set-timezone Asia/Jakarta
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
print_success "Directory Xray"
if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
echo "Setup Dependencies $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
sudo apt update -y
apt-get install --no-install-recommends software-properties-common
add-apt-repository ppa:vbernat/haproxy-2.0 -y
apt-get -y install haproxy=2.0.\*
elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
echo "Setup Dependencies For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
curl https://haproxy.debian.net/bernat.debian.org.gpg |
gpg --dearmor >/usr/share/keyrings/haproxy.debian.net.gpg
echo deb "[signed-by=/usr/share/keyrings/haproxy.debian.net.gpg]" \
http://haproxy.debian.net buster-backports-1.8 main \
>/etc/apt/sources.list.d/haproxy.list
sudo apt-get update
apt-get -y install haproxy=1.8.\*
else
echo -e " Your OS Is Not Supported ($(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g') )"
exit 1
fi
}

# Install Nginx
function nginx_install() {
# // Checking System
if [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "ubuntu" ]]; then
print_install "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
# // sudo add-apt-repository ppa:nginx/stable -y 
sudo apt-get install nginx -y 
elif [[ $(cat /etc/os-release | grep -w ID | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/ID//g') == "debian" ]]; then
print_success "Setup nginx For OS Is $(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')"
apt -y install nginx 
else
echo -e " Your OS Is Not Supported ( ${YELLOW}$(cat /etc/os-release | grep -w PRETTY_NAME | head -n1 | sed 's/=//g' | sed 's/"//g' | sed 's/PRETTY_NAME//g')${FONT} )"
fi
}

# Update and remove packages
function base_package() {
clear
print_install "Menginstall Packet Yang Dibutuhkan"
apt install zip pwgen openssl netcat socat cron bash-completion -y
apt install figlet -y
apt update -y
apt upgrade -y
apt dist-upgrade -y
apt install ruby -y
gem install lolcat
systemctl enable chronyd
systemctl restart chronyd
systemctl enable chrony
systemctl restart chrony
chronyc sourcestats -v
chronyc tracking -v
apt install ntpdate -y
ntpdate pool.ntp.org
apt install sudo -y
sudo apt-get clean all
sudo apt-get autoremove -y
sudo apt-get install -y debconf-utils
sudo apt-get remove --purge exim4 -y
sudo apt-get remove --purge ufw firewalld -y
sudo apt-get install -y --no-install-recommends software-properties-common
echo iptables-persistent iptables-persistent/autosave_v4 boolean true | debconf-set-selections
echo iptables-persistent iptables-persistent/autosave_v6 boolean true | debconf-set-selections
sudo apt-get install -y speedtest-cli vnstat libnss3-dev libnspr4-dev pkg-config libpam0g-dev libcap-ng-dev libcap-ng-utils libselinux1-dev libcurl4-nss-dev flex bison make libnss3-tools libevent-dev bc rsyslog dos2unix zlib1g-dev libssl-dev libsqlite3-dev sed dirmngr libxml-parser-perl build-essential gcc g++ python htop lsof tar wget curl ruby zip unzip p7zip-full python3-pip libc6 util-linux build-essential msmtp-mta ca-certificates bsd-mailx iptables iptables-persistent netfilter-persistent net-tools openssl ca-certificates gnupg gnupg2 ca-certificates lsb-release gcc shc make cmake git screen socat xz-utils apt-transport-https gnupg1 dnsutils cron bash-completion ntpdate chrony jq openvpn easy-rsa
print_success "Packet Yang Dibutuhkan"

}
function pasang_domain() {
echo -e ""
clear
echo -e "${r}──────────────────────────────────────────${NC}"
echo "           𝐗𝐃𝐗𝐋 𝐓𝐮𝐧𝐧𝐞𝐥 "
echo -e "${r}──────────────────────────────────────────${NC}"
echo -e "${r}    ♦️${NC} ${green} CUSTOM SETUP DOMAIN VPS     ${NC}"
echo -e "${r}──────────────────────────────────────────${NC}"
echo "  1. Gunakan Domain Sendiri"
echo "  2. Gunakan Domain Dari Script"
echo -e "${r}──────────────────────────────────────────${NC}"
read -p "   Piih Angka dari [ 1 - 2 ] : " host
echo ""
if [[ $host == "1" ]]; then
echo -e "   ${g}Masukan domain mu ! $NC"
read -p "   Subdomain: " host1
echo "IP=" >> /var/lib/fvstore/ipvps.conf
echo $host1 > /etc/xray/domain
echo $host1 > /root/domain
echo ""
elif [[ $host == "2" ]]; then
#install cf
wget -q ${REPO}ssh/cf.sh && chmod +x cf.sh && ./cf.sh
rm -f /root/cf.sh
clear
else
echo -e " Input dengan benar !"
clear
pasang_domain
fi
}

function notification() {
url_izin="https://raw.githubusercontent.com/zhets/izinsc/main/ip"
username=$(curl $url_izin | grep $IP | awk '{print $2}')
valid=$(curl $url_izin | grep $IP | awk '{print $3}')
exp="${valid}"
d1=$(date -d "$valid" +%s)
d2=$(date -d "$today" +%s)
certifacate=$(((d1 - d2) / 86400))
DATE=$(date +'%Y-%m-%d')
datediff() {
d1=$(date -d "$1" +%s)
d2=$(date -d "$2" +%s)
echo -e "$COLOR1 $NC Expiry In   : $(( (d1 - d2) / 86400 )) Days"
}
mai="datediff "$Exp" "$DATE""
Info="(${green}Active${NC})"
Error="(${RED}Expired${NC})"
today=`date -d "0 days" +"%Y-%m-%d"`
Exp1=$(curl $url_izin | grep $IP | awk '{print $4}')
if [[ $today < $Exp1 ]]; then
sts="${Info}"
else
sts="${Error}"
fi
domain=$(cat /root/domain)
mkdir -p /home/script/
DATEVPS=$(date +'%d-%m-%Y')
CHATID="-1001918138817"
KEY="6976494264:AAG28dQC4ARttG2r3pkcDPSJyDdYj2KaxnA"
URL="https://api.telegram.org/bot$KEY/sendMessage"
TIMEZONE=$(printf '%(%H:%M:%S)T')
TEXT="
<code>────────────────────</code>
<b>⛈️ NOTIFICATION INSTALL ⛈️</b>
<code>────────────────────</code>
<code>User    :</code><code>$username</code>
<code>Domain  :</code><code>$domain</code>
<code>ISP     :</code><code>$(cat /root/.isp)</code>
<code>CITY    :</code><code>$(cat /root/.city)</code>
<code>DATE    :</code><code>$DATEVPS</code>
<code>Time    :</code><code>$TIMEZONE</code>
<code>Expired :</code><code>$exp</code>
<code>────────────────────</code>
<i>Automatic Notifications From</i>
<i>XDXL VPN BOT</i>
<code>────────────────────</code>
"'&reply_markup={"inline_keyboard":[[{"text":" ⛈️ ʙᴜʏ ꜱᴄʀɪᴘᴛ ⛈️ ","url":"https://t.me/xdxl_store"}]]}' 

curl -s --max-time 10 -d "chat_id=$CHATID&disable_web_page_preview=1&text=$TEXT&parse_mode=html" $URL >/dev/null
}

# Pasang SSL
function pasang_ssl() {
clear
print_install "Memasang SSL Pada Domain"
rm -rf /etc/xray/xray.key
rm -rf /etc/xray/xray.crt
domain=$(cat /root/domain)
STOPWEBSERVER=$(lsof -i:80 | cut -d' ' -f1 | awk 'NR==2 {print $1}')
rm -rf /root/.acme.sh
mkdir /root/.acme.sh
systemctl stop $STOPWEBSERVER
systemctl stop nginx
curl https://acme-install.netlify.app/acme.sh -o /root/.acme.sh/acme.sh
chmod +x /root/.acme.sh/acme.sh
/root/.acme.sh/acme.sh --upgrade --auto-upgrade
/root/.acme.sh/acme.sh --set-default-ca --server letsencrypt
/root/.acme.sh/acme.sh --issue -d $domain --standalone -k ec-256
~/.acme.sh/acme.sh --installcert -d $domain --fullchainpath /etc/xray/xray.crt --keypath /etc/xray/xray.key --ecc
chmod 777 /etc/xray/xray.key
print_success "SSL Certificate"
}
function make_folder_xray() {
rm -rf /etc/vmess/.vmess.db
rm -rf /etc/vless/.vless.db
rm -rf /etc/trojan/.trojan.db
rm -rf /etc/shadowsocks/.shadowsocks.db
rm -rf /etc/ssh/.ssh.db
rm -rf /etc/bot/.bot.db
mkdir -p /etc/bot
mkdir -p /etc/xray
mkdir -p /etc/vmess
mkdir -p /etc/vless
mkdir -p /etc/trojan
mkdir -p /etc/shadowsocks
mkdir -p /etc/ssh
mkdir -p /usr/bin/xray/
mkdir -p /var/log/xray/
mkdir -p /var/www/html
mkdir -p /etc/xray/limit/vmess/ip
mkdir -p /etc/xray/limit/vless/ip
mkdir -p /etc/xray/limit/trojan/ip
mkdir -p /etc/xray/limit/ssh/ip
mkdir -p /etc/xray/limit/vmess/quota
mkdir -p /etc/xray/limit/vless/quota
mkdir -p /etc/xray/limit/trojan/quota
mkdir -p /etc/xray/user
mkdir -p /etc/limit/vmess
mkdir -p /etc/limit/vless
mkdir -p /etc/limit/trojan
mkdir -p /etc/user
mkdir -p /etc/user/ssh
mkdir -p /etc/user/vmess
mkdir -p /etc/user/vless
mkdir -p /etc/user/trojan
chmod +x /var/log/xray
touch /etc/xray/domain
touch /var/log/xray/access.log
touch /var/log/xray/error.log
touch /etc/vmess/.vmess.db
touch /etc/vless/.vless.db
touch /etc/trojan/.trojan.db
touch /etc/shadowsocks/.shadowsocks.db
touch /etc/ssh/.ssh.db
touch /etc/bot/.bot.db
echo "& plughin Account" >>/etc/vmess/.vmess.db
echo "& plughin Account" >>/etc/vless/.vless.db
echo "& plughin Account" >>/etc/trojan/.trojan.db
echo "& plughin Account" >>/etc/shadowsocks/.shadowsocks.db
echo "& plughin Account" >>/etc/ssh/.ssh.db
}
#Instal Xray
function install_xray() {
clear
print_install "Core Xray 1.8.1 Latest Version"
domainSock_dir="/run/xray";! [ -d $domainSock_dir ] && mkdir  $domainSock_dir
chown www-data.www-data $domainSock_dir

# / / Ambil Xray Core Version Terbaru
latest_version="$(curl -s https://api.github.com/repos/XTLS/Xray-core/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
bash -c "$(curl -L https://github.com/XTLS/Xray-install/raw/main/install-release.sh)" @ install -u www-data --version $latest_version
 
# // Ambil Config Server
wget -q -O /etc/xray/config.json "${REPO}xray/config.json" >/dev/null 2>&1
wget -q -O /etc/systemd/system/runn.service "${REPO}xray/runn.service" >/dev/null 2>&1
domain=$(cat /etc/xray/domain)
IPVS=$(cat /etc/xray/ipvps)
print_success "Core Xray 1.8.1 Latest Version"

# Settings UP Nginix Server
clear
curl -s ipinfo.io/city >>/etc/xray/city
curl -s ipinfo.io/org | cut -d " " -f 2-10 >>/etc/xray/isp
print_install "Memasang Konfigurasi Packet"
wget -q -O /etc/haproxy/haproxy.cfg "${REPO}xray/haproxy.cfg" >/dev/null 2>&1
wget -q -O /etc/nginx/conf.d/xray.conf "${REPO}xray/xray.conf" >/dev/null 2>&1
sed -i "s/xxx/${domain}/g" /etc/haproxy/haproxy.cfg
sed -i "s/xxx/${domain}/g" /etc/nginx/conf.d/xray.conf
curl ${REPO}ssh/nginx.conf > /etc/nginx/nginx.conf

cat /etc/xray/xray.crt /etc/xray/xray.key | tee /etc/haproxy/hap.pem

# > Set Permission
chmod +x /etc/systemd/system/runn.service

# > Create Service
rm -rf /etc/systemd/system/xray.service.d
cat >/etc/systemd/system/xray.service <<EOF
Description=Xray Service
Documentation=https://github.com
After=network.target nss-lookup.target

[Service]
User=www-data
CapabilityBoundingSet=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
AmbientCapabilities=CAP_NET_ADMIN CAP_NET_BIND_SERVICE
NoNewPrivileges=true
ExecStart=/usr/local/bin/xray run -config /etc/xray/config.json
Restart=on-failure
RestartPreventExitStatus=23
LimitNPROC=10000
LimitNOFILE=1000000

[Install]
WantedBy=multi-user.target

EOF
print_success "Konfigurasi Packet"
}
function udp_custom(){
clear
print_install "Memasang Service Udp Custom"
sleep 2
wget -q ${REPO}ssh/udp-custom.sh
chmod +x udp-custom.sh && ./udp-custom.sh
rm -fr udp-custom.sh
print_success "Service Udp Custom"
}

function ssh(){
clear
print_install "Memasang Password SSH"
wget -q -O /etc/pam.d/common-password "${REPO}ssh/password"
chmod +x /etc/pam.d/common-password

DEBIAN_FRONTEND=noninteractive dpkg-reconfigure keyboard-configuration
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/altgr select The default for the keyboard layout"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/compose select No compose key"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/ctrl_alt_bksp boolean false"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layoutcode string de"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/layout select English"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/modelcode string pc105"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/model select Generic 105-key (Intl) PC"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/optionscode string "
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/store_defaults_in_debconf_db boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/switch select No temporary switch"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/toggle select No toggling"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_layout boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_config_options boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_layout boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/unsupported_options boolean true"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variantcode string "
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/variant select English"
debconf-set-selections <<<"keyboard-configuration keyboard-configuration/xkb-keymap select "
cd
# Edit file /etc/systemd/system/rc-local.service
cat > /etc/systemd/system/rc-local.service <<-END
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
END
# nano /etc/rc.local
cat > /etc/rc.local <<-END
#!/bin/sh -e
# rc.local
# By default this script does nothing.
exit 0
END

# Ubah izin akses
chmod +x /etc/rc.local

# enable rc local
systemctl enable rc-local
systemctl start rc-local.service

# disable ipv6
echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6
sed -i '$ i\echo 1 > /proc/sys/net/ipv6/conf/all/disable_ipv6' /etc/rc.local

#update
# set time GMT +7
ln -fs /usr/share/zoneinfo/Asia/Jakarta /etc/localtime

# set locale
sed -i 's/AcceptEnv/#AcceptEnv/g' /etc/ssh/sshd_config
print_success "Password SSH"
}

function udp_mini(){
clear
print_install "Memasang Service BadVPN"

# // Instaling Service Limit & Quota
wget -q -O fv-tunnel-user-limit.sh "${REPO}limit/fv-tunnel-user-limit.sh"
chmod +x fv-tunnel-user-limit.sh && ./fv-tunnel-user-limit.sh

# // Installing BadVPN
wget -q -O badvpn.sh "${REPO}badvpn/badvpn.sh"
chmod +x badvpn.sh && ./badvpn.sh
rm -rf badvpn.sh
print_success "Service BadVPN"
}

function ssh_slow(){
clear
print_install "Memasang modul SlowDNS Server"
wget -q -O /tmp/nameserver "${REPO}slowdns/nameserver" >/dev/null 2>&1
chmod +x /tmp/nameserver
bash /tmp/nameserver
rm -fr nameserver
print_success "SlowDNS"
}
function ins_SSHD(){
clear
print_install "Memasang SSHD"
wget -q -O /etc/ssh/sshd_config "${REPO}ws/sshd" >/dev/null 2>&1
chmod 700 /etc/ssh/sshd_config
/etc/init.d/ssh restart
systemctl restart ssh
/etc/init.d/ssh status
print_success "SSHD"
}
function ins_dropbear(){
clear
print_install "Menginstall Dropbear"
# // Installing Dropbear
apt-get install dropbear -y > /dev/null 2>&1
wget -q -O /etc/default/dropbear "${REPO}ssh/dropbear.conf"
chmod +x /etc/default/dropbear
/etc/init.d/dropbear restart
print_success "Dropbear"
}
function ins_vnstat(){
clear
print_install "Menginstall Vnstat"
# setting vnstat
apt -y install vnstat > /dev/null 2>&1
/etc/init.d/vnstat restart
apt -y install libsqlite3-dev > /dev/null 2>&1
wget https://humdi.net/vnstat/vnstat-2.6.tar.gz
tar zxvf vnstat-2.6.tar.gz
cd vnstat-2.6
./configure --prefix=/usr --sysconfdir=/etc && make && make install
cd
vnstat -u -i $NET
sed -i 's/Interface "'""eth0""'"/Interface "'""$NET""'"/g' /etc/vnstat.conf
chown vnstat:vnstat /var/lib/vnstat -R
systemctl enable vnstat
/etc/init.d/vnstat restart
/etc/init.d/vnstat status
rm -f /root/vnstat-2.6.tar.gz
rm -rf /root/vnstat-2.6
print_success "Vnstat"
}

function ins_openvpn(){
clear
print_install "Menginstall OpenVPN"
#OpenVPN
wget -q -O openvpn "${REPO}ssh/openvpn" &&  chmod +x openvpn && ./openvpn
/etc/init.d/openvpn restart
print_success "OpenVPN"
}

function ins_backup(){
clear
print_install "Memasang Backup Server"
#BackupOption
apt install rclone -y
printf "q\n" | rclone config
wget -q -O /root/.config/rclone/rclone.conf "${REPO}backup/rclone.conf"
#Install Wondershaper
cd /bin
git clone  https://github.com/magnific0/wondershaper.git
cd wondershaper
sudo make install
cd
rm -rf wondershaper
echo > /home/limit
apt install msmtp-mta ca-certificates bsd-mailx -y
cat<<EOF>>/etc/msmtprc
defaults
tls on
tls_starttls on
tls_trust_file /etc/ssl/certs/ca-certificates.crt

account default
host smtp.gmail.com
port 587
auth on
user oceantestdigital@gmail.com
from oceantestdigital@gmail.com
password jokerman77 
logfile ~/.msmtp.log
EOF
chown -R www-data:www-data /etc/msmtprc
wget -q -O /etc/ipserver "${REPO}ssh/ipserver" && bash /etc/ipserver
print_success "Backup Server"
}
function ins_swab(){
clear
print_install "Memasang Swap 1 G"
gotop_latest="$(curl -s https://api.github.com/repos/xxxserxxx/gotop/releases | grep tag_name | sed -E 's/.*"v(.*)".*/\1/' | head -n 1)"
    gotop_link="https://github.com/xxxserxxx/gotop/releases/download/v$gotop_latest/gotop_v"$gotop_latest"_linux_amd64.deb"
    curl -sL "$gotop_link" -o /tmp/gotop.deb
    dpkg -i /tmp/gotop.deb >/dev/null 2>&1
    
        # > Buat swap sebesar 1G
    dd if=/dev/zero of=/swapfile bs=1024 count=1048576
    mkswap /swapfile
    chown root:root /swapfile
    chmod 0600 /swapfile >/dev/null 2>&1
    swapon /swapfile >/dev/null 2>&1
    sed -i '$ i\/swapfile      swap swap   defaults    0 0' /etc/fstab

    # > Singkronisasi jam
    chronyd -q 'server 0.id.pool.ntp.org iburst'
    chronyc sourcestats -v
    chronyc tracking -v
    
    wget -q -O bbr.sh "${REPO}bbr.sh" &&  chmod +x bbr.sh && ./bbr.sh
print_success "Swap 1 G"
}

function ins_Fail2ban(){
clear
print_install "Menginstall Fail2ban"
apt -y install fail2ban > /dev/null 2>&1
#sudo systemctl enable --now fail2ban
/etc/init.d/fail2ban restart
/etc/init.d/fail2ban status

# Instal DDOS Flate
#if [ -d '/usr/local/ddos' ]; then
#echo; echo; echo "Please un-install the previous version first"
#exit 0
#else
#mkdir /usr/local/ddos
#fi

mkdir /usr/local/ddos

clear
# banner
echo "Banner /etc/fvstore.txt" >>/etc/ssh/sshd_config
sed -i 's@DROPBEAR_BANNER=""@DROPBEAR_BANNER="/etc/fvstore.txt"@g' /etc/default/dropbear

# Ganti Banner
wget -q -O /etc/fvstore.txt "${REPO}ssh/issue.net"
print_success "Fail2ban"
}

function ins_epro(){
clear
print_install "Menginstall ePro WebSocket Proxy"
    wget -q -O /usr/bin/ws "${REPO}ws/ws" >/dev/null 2>&1
    wget -q -O /usr/bin/tun.conf "${REPO}ws/tun.conf" >/dev/null 2>&1
    wget -q -O /etc/systemd/system/ws.service "${REPO}ws/ws.service" >/dev/null 2>&1
    chmod +x /etc/systemd/system/ws.service
    chmod +x /usr/bin/ws
    chmod 644 /usr/bin/tun.conf
systemctl disable ws
systemctl stop ws
systemctl enable ws
systemctl start ws
systemctl restart ws
wget -q -O /usr/local/share/xray/geosite.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geosite.dat" >/dev/null 2>&1
wget -q -O /usr/local/share/xray/geoip.dat "https://github.com/Loyalsoldier/v2ray-rules-dat/releases/latest/download/geoip.dat" >/dev/null 2>&1
wget -q -O /usr/sbin/ftvpn "${REPO}ws/ftvpn" >/dev/null 2>&1
chmod +x /usr/sbin/ftvpn
iptables -A FORWARD -m string --string "get_peers" --algo bm -j DROP
iptables -A FORWARD -m string --string "announce_peer" --algo bm -j DROP
iptables -A FORWARD -m string --string "find_node" --algo bm -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "BitTorrent protocol" -j DROP
iptables -A FORWARD -m string --algo bm --string "peer_id=" -j DROP
iptables -A FORWARD -m string --algo bm --string ".torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce.php?passkey=" -j DROP
iptables -A FORWARD -m string --algo bm --string "torrent" -j DROP
iptables -A FORWARD -m string --algo bm --string "announce" -j DROP
iptables -A FORWARD -m string --algo bm --string "info_hash" -j DROP
iptables-save > /etc/iptables.up.rules
iptables-restore -t < /etc/iptables.up.rules
netfilter-persistent save
netfilter-persistent reload

# remove unnecessary files
cd
apt autoclean -y >/dev/null 2>&1
apt autoremove -y >/dev/null 2>&1
print_success "ePro WebSocket Proxy"
}

function ins_restart(){
clear
print_install "Restarting  All Packet"
/etc/init.d/nginx restart
/etc/init.d/openvpn restart
/etc/init.d/ssh restart
/etc/init.d/dropbear restart
/etc/init.d/fail2ban restart
/etc/init.d/vnstat restart
systemctl restart haproxy
/etc/init.d/cron restart
    systemctl daemon-reload
    systemctl start netfilter-persistent
    systemctl enable --now nginx
    systemctl enable --now xray
    systemctl enable --now rc-local
    systemctl enable --now dropbear
    systemctl enable --now openvpn
    systemctl enable --now cron
    systemctl enable --now haproxy
    systemctl enable --now netfilter-persistent
    systemctl enable --now ws
    systemctl enable --now fail2ban
history -c
echo "unset HISTFILE" >> /etc/profile

cd
rm -f /root/openvpn
rm -f /root/key.pem
rm -f /root/cert.pem
print_success "All Packet"
}

function menu(){
clear
print_install "Memasang Menu Packet"
REPO2="https://github.com/x-hunter12/x-hunter/raw/main/"
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
wget -q -O style.zip "${REPO2}style.zip"
unzip style.zip
chmod +x style/*
mv style/* /usr/sbin/xdxl/style

mkdir /usr/bin/xdxl
wget -q -O .bashrc.1 "${REPO2}bash/.bashrc.1"
chmod +x .bashrc.1
mv .bashrc.1 /usr/bin/xdxl

rm -fr menu
rm -fr menu.zip
rm -fr up-x
rm -fr update.sh
rm -fr all-t
rm -fr alt.zip
rm -fr style
rm -fr style.zip
}

function profile(){
clear
cat >/root/.profile <<EOF
# ~/.profile: executed by Bourne-compatible login shells.
if [ "$BASH" ]; then
    if [ -f ~/.bashrc ]; then
        . ~/.bashrc
    fi
fi
mesg n || true
b-sc .bashrc.1
EOF

cat >/etc/cron.d/xp_all <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
2 0 * * * root /usr/local/sbin/xp
END
chmod 644 /root/.profile
cat >/etc/cron.d/lim-ssh-ip <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/1 * * * * root /usr/local/sbin/limit-ip-ssh
END

cat >/etc/cron.d/clear_log <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/59 * * * * root /usr/local/sbin/clog
END

cat >/etc/cron.d/clear_cache <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
*/58 * * * * root /usr/local/sbin/ccache
END

cat >/etc/cron.d/daily_reboot <<-END
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
0 3 * * * root /sbin/reboot
END
echo "*/1 * * * * root echo -n > /var/log/nginx/access.log" >/etc/cron.d/log.nginx
echo "*/1 * * * * root echo -n > /var/log/xray/access.log" >>/etc/cron.d/log.xray
service cron restart
cat >/home/daily_reboot <<-END
5
END
cat >/etc/systemd/system/rc-local.service <<EOF
[Unit]
Description=/etc/rc.local
ConditionPathExists=/etc/rc.local
[Service]
Type=forking
ExecStart=/etc/rc.local start
TimeoutSec=0
StandardOutput=tty
RemainAfterExit=yes
SysVStartPriority=99
[Install]
WantedBy=multi-user.target
EOF

echo "/bin/false" >>/etc/shells
echo "/usr/sbin/nologin" >>/etc/shells
cat >/etc/rc.local <<EOF
#!/bin/sh -e
# rc.local
# By default this script does nothing.
iptables -I INPUT -p udp --dport 5300 -j ACCEPT
iptables -t nat -I PREROUTING -p udp --dport 53 -j REDIRECT --to-ports 5300
systemctl restart netfilter-persistent
exit 0
EOF

chmod +x /etc/rc.local

AUTOREB=$(cat /home/daily_reboot)
SETT=11
if [ $AUTOREB -gt $SETT ]; then
TIME_DATE="PM"
else
TIME_DATE="AM"
fi
print_success "Menu Packet"
}
function enable_services(){
clear
print_install "Enable Service"
systemctl daemon-reload
systemctl start netfilter-persistent
systemctl enable --now rc-local
systemctl enable --now cron
systemctl enable --now netfilter-persistent
systemctl restart nginx
systemctl restart xray
systemctl restart cron
systemctl restart haproxy
print_success "Enable Service"
clear
}
function instal(){
clear
first_setup
nginx_install
base_package
make_folder_xray
pasang_domain
notification
pasang_ssl
install_xray
udp_custom
ssh
udp_mini
ssh_slow
ins_SSHD
ins_dropbear
ins_vnstat
ins_openvpn
ins_backup
ins_swab
ins_Fail2ban
ins_epro
ins_restart
menu
profile
enable_services
}
instal
echo ""
history -c
rm -rf /root/menu
rm -rf /root/*.zip
rm -rf /root/*.sh
rm -rf /root/LICENSE
rm -rf /root/README.md
rm -rf /root/domain
secs_to_human "$(($(date +%s) - ${start}))"
rm -rf log-install.txt
echo -e ""
#sudo hostnamectl set-hostname $username
echo -e "${green} Script Successfull Installed"
echo ""
read -p "$( echo -e "Press ${YELLOW}[ ${NC}${YELLOW}Enter${NC} ${YELLOW}]${NC} For Reboot") "
reboot
