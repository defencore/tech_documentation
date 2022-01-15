# Teltonika TRB140
```
  DEVICE: Teltonika TRB140
      CPU: Qualcomm Technologies, Inc MDM9207
   SERIAL: XXXXXXXXXX
RNDIS_MAC: E6:B2:5D:XX:XX:XX
  ETH_MAC: 00:1E:42:XX:XX:XX
    MODEM: EC25-EU EC25EUGA-512-SGNS
 FIRMWARE: EC25EUGAR06A05M4G_BETA1108
 ```
## Firmware Building
### Host | Docker Installation
```
└─$ sudo apt-get update
└─$ sudo apt-get upgrade
└─$ sudo apt-get install docker.io
└─$ sudo usermod -aG docker ${USER}
└─$ su - ${USER}
└─$ id -nG
└─$ docker pull ubuntu
└─$ docker images
```
### Host | Prepare Teltonika SDK
```
└─$ mkdir ~/teltonika
└─$ cd ~/teltonika
└─$ wget https://wiki.teltonika-networks.com/gpl/TRB1_R_GPL_00.07.01.2.tar.gz
└─$ tar -xvf TRB1_R_GPL_00.07.01.2.tar.gz
└─$ docker run -v ~/teltonika/:/home/teltonika -it ubuntu:bionic /bin/bash
```
### Docker | System Preparation
```
# System update
root@cc52108af770:/# apt-get update
root@cc52108af770:/# apt-get upgrade
# Adding a user
root@cc52108af770:/# useradd teltonika -b /home -d /home/teltonika -s /bin/bash
# Installing dependencies
root@cc52108af770:/# apt-get -y install bc libncurses-dev wget rsync nodejs npm jq
root@cc52108af770:/# apt-get -y install binutils binutils-gold build-essential bzip2 curl device-tree-compiler devscripts file flex fuse g++ gawk gcc gcc-multilib gengetopt gettext git groff libc6-dev libncurses5-dev libpcre3-dev libssl-dev libxml-parser-perl make ocaml ocaml-findlib ocaml-nox patch pkg-config python2.7 python-dev python-yaml sharutils subversion u-boot-tools unzip vim-common wget zlib1g-dev dialog
```
### Docker | Building The Firmware
```
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
---
 
## Firmware Extraction
### EDL
 First you need to switch Teltonika TRB140 to EDL _(Qualcomm 9008 Emergency Download)_ mode.
 To do this, in EC25 modules, you need to apply 1.8V to the USB_BOOT contact through a 10K resistor.
 ``` 
 PIN 7   = VDD_EXT (1.8V)
 PIN 115 = USB_BOOT
 ```
 But apparently, the manufacturer has blocked this possibility. At least I didn’t manage to switch Teltonika TRB140 to EDL mode by this way.
 So I had to go another way
### EDL via ADB
 Boot Teltonika TRB140 and connect to PC via USB
```
# Connect to TRB140 via SSH
└─$ ssh root@192.168.2.1
# Start ADB Server
root@Teltonika-TRB140:~# adbd
root@Teltonika-TRB140:~# exit
# Connect to ADB
└─$ adb connect 192.168.2.1:5555
* daemon not running; starting now at tcp:5037
* daemon started successfully
connected to 192.168.2.1:5555
# Reboot to EDL
└─$ adb reboot edl
```
```
└─$ dmesg
[362492.038910] usb 1-4: New USB device found, idVendor=05c6, idProduct=9008, bcdDevice= 0.00
[362492.038917] usb 1-4: New USB device strings: Mfr=1, Product=2, SerialNumber=0
[362492.038920] usb 1-4: Product: QHSUSB__BULK
[362492.038922] usb 1-4: Manufacturer: Qualcomm CDMA Technologies MSM
[362492.040306] qcserial 1-4:1.0: Qualcomm USB modem converter detected
[362492.040414] usb 1-4: Qualcomm USB modem converter now attached to ttyUSB0
```
### EDL by bkerler
```
└─$ git clone https://github.com/bkerler/edl.git
└─$ cd edl
└─$ git submodule update --init --recursive
└─$ python setup.py build
└─$ sudo python setup.py install
└─$ sudo cp Drivers/51-edl.rules /etc/udev/rules.d
└─$ sudo cp Drivers/50-android.rules /etc/udev/rules.d
```
#### Get device info
```
# Print GPT Table information
└─$ edl printgpt
# Print secureboot fields from qfprom fuses
└─$ edl secureboot
```
```
HWID:              0x000480e100000000 (MSM_ID:0x000480e1,OEM_ID:0x0000,MODEL_ID:0x0000)
CPU detected:      "MDM9207"
PK_HASH:           0xcc3153a80293939b90d02d3bf8b23e0292e452fef662c74998421adad42a380f
Serial:            0xf3f6ef32

Sec_Boot0 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Sec_Boot1 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Sec_Boot2 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Sec_Boot3 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Secure boot disabled.

Streaming - Chipset: 9x07
Streaming - Base address of the NAND controller: 079b0000
Streaming - Sector size: 516 bytes
Streaming - Spare bytes: 4 bytes
Streaming - Defective block marker position: spare+6
Streaming - The total size of the flash memory = 4096 blocks (512 MB)
Streaming - Flash memory: Hynix MD5N04G02GHD2ARKG, NAND 512MiB 1.8V 8-bit
Streaming - Page size: 2048 bytes (4 sectors)
Streaming - The number of pages in the block: 64
Streaming - OOB size: 64 bytes
Streaming - ECC: BCH, 4 bit
Streaming - ЕСС size: 1 bytes

Name                    Offset          Length          Attr            Flash
-----------------------------------------------------------------------------
sbl                     00000000        00140000        0xff/0x1/0x0    0
mibib                   00140000        00140000        0xff/0x1/0xff   0
efs2                    00280000        01600000        0xff/0x1/0xff   0
rawdata                 01880000        00300000        0xff/0x1/0x0    0
tz                      01B80000        00140000        0xff/0x1/0x0    0
rpm                     01CC0000        00140000        0xff/0x1/0x0    0
aboot                   01E00000        00140000        0xff/0x1/0x0    0
mnf_info                01F40000        00140000        0xff/0x1/0x0    0
boot_config             02080000        00140000        0xff/0x1/0x0    0
boot_a                  021C0000        00900000        0xff/0x1/0x0    0
boot_b                  02AC0000        00900000        0xff/0x1/0x0    0
modem                   033C0000        03C00000        0xff/0x1/0x0    0
rootfs_a                06FC0000        07740000        0xff/0x1/0x0    0
rootfs_b                0E700000        07740000        0xff/0x1/0x0    0
storage                 15E40000        0A1C0000        0xff/0x1/0x0    0
```
#### Dump memory
```
# Read all partitions from flash to a directory ./partitions
└─$ edl rl partitions
# Read whole flash to file (takes a very long time)
└─$ edl rf trb140_full_dump.bin
```

### Info
```
root@Teltonika-TRB140:~# cat /etc/opkg/teltonikafeeds.conf 
src/gz tlt_packages http://opkg.teltonika-networks.com/47e3786ceae65d0db0a418432314e5714720f6e938e005847e8de2b42c62bb13
root@Teltonika-TRB140:~# cat /etc/opkg/distfeeds.conf 
src/gz openwrt_core http://downloads.openwrt.org/releases/19.07.7/targets/mdm9x07/generic/packages
src/gz openwrt_base http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/base
src/gz openwrt_freifunk http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/freifunk
src/gz openwrt_luci http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/luci
src/gz openwrt_packages http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/packages
src/gz openwrt_routing http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/routing
src/gz openwrt_telephony http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/telephony
src/gz openwrt_vuci http://downloads.openwrt.org/releases/19.07.7/packages/arm_cortex-a7_neon-vfpv4/vuci
```


### Usefull Links & References:
- [Teltonika SDK](https://wiki.teltonika-networks.com/view/Software_Development_Kit)
- [Quectel Tools](https://www.quectel.com/ProductDownload/EC20.zip)
- [Qualcomm Sahara / Firehose Attack Client / Diag Tools by Bjoern Kerler](https://github.com/bkerler/edl)
- [OpenPST Sahara](https://github.com/openpst/sahara)
- [Firehose Finder by hoplik](https://github.com/hoplik/Firehose-Finder)
