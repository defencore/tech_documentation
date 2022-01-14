# Teltonika TRB140 Firmware Extraction

```
  DEVICE: Teltonika TRB140
      CPU: Qualcomm Technologies, Inc MDM9207
   SERIAL: XXXXXXXXXX
RNDIS_MAC: E6:B2:5D:XX:XX:XX
  ETH_MAC: 00:1E:42:XX:XX:XX
    MODEM: EC25-EU EC25EUGA-512-SGNS
 FIRMWARE: EC25EUGAR06A05M4G_BETA1108
 ```
 
 ## Prepare System
 ```
└─$ sudo apt-get update
└─$ sudo apt-get upgrade
```
### Docker
```
└─$ sudo apt-get install docker.io
└─$ sudo usermod -aG docker ${USER}
└─$ su - ${USER}
└─$ id -nG
└─$ docker pull ubuntu
└─$ docker images
 ```
 ```
 └─$ docker run -it ubuntu
 docker run -v /path/to/teltonika/sdk/:/home/user -it ubuntu:bionic /bin/bash
root@eafcde41015e:/# cd /home/user/RUT240
root@eafcde41015e:/# apt-get update
root@eafcde41015e:/# apt-get -y install bc libncurses-dev wget rsync nodejs npm
root@eafcde41015e:/# apt install -y binutils binutils-gold build-essential bzip2 curl device-tree-compiler devscripts file flex fuse g++ gawk gcc gcc-multilib gengetopt gettext git groff libc6-dev libncurses5-dev libpcre3-dev libssl-dev libxml-parser-perl make ocaml ocaml-findlib ocaml-nox patch pkg-config python2.7 python-dev python-yaml sharutils subversion u-boot-tools unzip vim-common wget zlib1g-dev dialog
root@eafcde41015e:/# ./scripts/feeds update -a
root@eafcde41015e:/# make menuconfig
	Target System (Atheros AR7xxx/AR9xxx)  --->
	Target Profile (Teltonika RUT200)  --->
	Network  --->
		Web Servers/Proxies  --->
			< > privoxy
		VPN  --->
			<*> tlt_custom_pkg_wireguard
root@eafcde41015e:/# export FORCE_UNSAFE_CONFIGURE=1
root@eafcde41015e:/# make V=s -j$(nproc)
root@eafcde41015e:/# file bin/ar71xx/openwrt-ar71xx-generic-tlt-rut200-squashfs-sysupgrade.bin
 ```
 
 
 
### References:
- [Teltonika SDK](https://wiki.teltonika-networks.com/view/Software_Development_Kit)
- [Quectel Tools](https://www.quectel.com/ProductDownload/EC20.zip)
- [Qualcomm Sahara / Firehose Attack Client / Diag Tools by Bjoern Kerler](https://github.com/bkerler/edl)
