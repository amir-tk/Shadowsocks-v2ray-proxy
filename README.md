# Shadowsocks with v2ray plugin

# Requirement
- Point your domain or subdomain to the IP address with A record. (You can use Cloudflare)
- A VPS with Ubuntu 18.04 or 20.04 or 22.04

## Install Shadowsocks, v2ray Plugin and Certbot
To install Shadowsocks with v2ray plugin, just run command on your Ubuntu machine.
```bash
wget https://t.ly/yjlW && bash ssv2ray.sh
```

## Configure iptables

Run this command on your internal server:
```bash
wget https://t.ly/vme0 && bash iptables-internal.sh
```

Run this command on your external server:
```
wget https://t.ly/SuHM && bash iptables-external.sh
```

If you want to use tunneling, use the internal server IP instead of the external IP in the Shadowsocks client.


## Clients
- iOS: [Shadowrocket](https://apps.apple.com/us/app/shadowrocket/id932747118)
- Android: [Shadowsocks](https://play.google.com/store/apps/details?id=com.github.shadowsocks&hl=en&gl=US) - [V2ray Plugin](https://play.google.com/store/apps/details?id=com.github.shadowsocks.plugin.v2ray&hl=en&gl=US)
- Windows: [Shadowsocks](https://github.com/shadowsocks/shadowsocks-windows/releases) - [V2ray Plugin](https://github.com/shadowsocks/v2ray-plugin/releases)
- Linux: [Shadowsocks](#) - [V2ray Plugin](https://github.com/shadowsocks/v2ray-plugin/releases)

#### Under construction.
