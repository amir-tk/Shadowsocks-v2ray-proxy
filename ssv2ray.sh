#!/bin/bash

# Simple script to run shadowsocks with v2ray plugin under ssl

set_colors() {
  clear
  NC="\033[0m"
  GREEN="\033[0;32m"
  YELLOW="\033[0;33m"
}

# Set Password
set_password() {
  read -p "Please enter password for shadowsocks (press ENTER for default: Linuxmaster14!) " password
  [ -z "${password}" ] && password="Linuxmaster14!"
}

# Set Domain Name A Record
set_domain() {
  read -p "Please enter your Domain Name A Record: " domain
}

# Install Shadowsocks
conf_ss() {
  apt update -y
  if [ -f /usr/bin/ss-server ]; then
      echo "Shadowsocks-libev already installed! Skip ...."
  else
      apt install shadowsocks-libev -y
  fi
  cat >/etc/shadowsocks-libev/config.json << EOF
{
  "server":"0.0.0.0",
  "server_port":443,
  "password":"$password",
  "timeout":300,
  "method":"aes-256-gcm",
  "plugin":"v2ray-plugin",
  "plugin_opts":"server;tls;cert=/etc/letsencrypt/live/$domain/fullchain.pem;key=/etc/letsencrypt/live/$domain/privkey.pem;host=$domain;loglevel=none"
}
EOF
  cat >/lib/systemd/system/shadowsocks-libev.service << EOF
[Unit]
Description=Shadowsocks-libev Server Service
After=network.target
[Service]
ExecStart=/usr/bin/ss-server -c /etc/shadowsocks-libev/config.json
Restart=on-failure
[Install]
WantedBy=multi-user.target
EOF
  systemctl daemon-reload
  systemctl restart shadowsocks-libev.service
}

# Download v2ray plugin
conf_v2ray() {
  if [ -f /usr/local/bin/v2ray-plugin ]; then
    echo "v2ray-plugin already installed! Skip ..."
  else
    v2_file=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep linux-amd64 | grep name | cut -f4 -d\")
    v2_url=$(wget -qO- https://api.github.com/repos/shadowsocks/v2ray-plugin/releases/latest | grep linux-amd64 | grep browser_download_url | cut -f4 -d\")
    wget $v2_url
    tar xvf $v2_file
    mv v2ray-plugin_linux_amd64 /usr/local/bin/v2ray-plugin
    echo "V2ray is installed."
    echo ""
  fi
}

# Install certbot
get_cert() {
if [ -f /etc/letsencrypt/live/$domain/fullchain.pem ]; then
  echo "Letsencrypt cert for ${domain}} existed! Skip ..."
else
  if ! which certbot > /dev/null; then
    apt install certbot -y
    echo "Certbot is installed."
  fi
  certbot certonly --cert-name $domain -d $domain --standalone --agree-tos --register-unsafely-without-email
  # systemctl enable certbot.timer --now
  echo "Successfully received certificate for $domain."
fi
}

# Print information
print_conf() {
  clear
  echo -e "Your installation has been done."
  echo -e "Please use the following information to connect from your client."
  echo ""
  echo -e "${GREEN}Server IP:${NC}           ${YELLOW}${domain}${NC}"
  echo -e "${GREEN}Server Port:${NC}         ${YELLOW}443${NC}"
  echo -e "${GREEN}Password:${NC}            ${YELLOW}${password}${NC}"
  echo -e "${GREEN}Encryption Method:${NC}   ${YELLOW}aes-256-gcm${NC}"
  echo -e "${GREEN}Plugin:${NC}              ${YELLOW}v2ray-plugin${NC}"
  echo -e "${GREEN}Plugin options:${NC}      ${YELLOW}tls;host=${domain}${NC}"
  echo ""
}

set_colors
set_password
set_domain
conf_ss
conf_v2ray
get_cert
print_conf
