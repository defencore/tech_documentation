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
### Docker Installation
```
└─$ sudo apt-get install docker.io
└─$ sudo usermod -aG docker ${USER}
└─$ su - ${USER}
└─$ id -nG
└─$ docker pull ubuntu
└─$ docker images
```

### Prepare Teltonika SDK
```
└─$ mkdir ~/teltonika
└─$ cd ~/teltonika
└─$ wget https://wiki.teltonika-networks.com/gpl/TRB1_R_GPL_00.07.01.2.tar.gz
└─$ tar -xvf TRB1_R_GPL_00.07.01.2.tar.gz
└─$ docker run -v ~/teltonika/:/home/teltonika -it ubuntu:bionic /bin/bash
```
```
root@cc52108af770:/# apt-get update
root@cc52108af770:/# apt-get upgrade

root@cc52108af770:/# useradd teltonika -b /home -d /home/teltonika -s /bin/bash

root@cc52108af770:/# apt-get -y install bc libncurses-dev wget rsync nodejs npm jq
root@cc52108af770:/# apt install -y binutils binutils-gold build-essential bzip2 curl device-tree-compiler devscripts file flex fuse g++ gawk gcc gcc-multilib gengetopt gettext git groff libc6-dev libncurses5-dev libpcre3-dev libssl-dev libxml-parser-perl make ocaml ocaml-findlib ocaml-nox patch pkg-config python2.7 python-dev python-yaml sharutils subversion u-boot-tools unzip vim-common wget zlib1g-dev dialog
root@cc52108af770:/# su teltonika
teltonika@cc52108af770:~$ cd ~/rutos-mdm9x07-trb1-gpl
teltonika@cc52108af770:~$ ./scripts/feeds update -a
teltonika@cc52108af770:~$ make menuconfig
	Target System (Atheros AR7xxx/AR9xxx)  --->
	Target Profile (Teltonika TRB140 EC25-EU (Region 0))  --->
	        (X) Teltonika TRB140 EC25-EU (Region 0)
teltonika@cc52108af770:~$ make V=s -j$(nproc)
teltonika@cc52108af770:~$ file bin/ar71xx/openwrt-ar71xx-generic-tlt-rut200-squashfs-sysupgrade.bin
 ```
 
 
 
### References:
- [Teltonika SDK](https://wiki.teltonika-networks.com/view/Software_Development_Kit)
- [Quectel Tools](https://www.quectel.com/ProductDownload/EC20.zip)
- [Qualcomm Sahara / Firehose Attack Client / Diag Tools by Bjoern Kerler](https://github.com/bkerler/edl)
