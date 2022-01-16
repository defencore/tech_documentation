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

### Partitions
#### SBL
```
└─$ strings -a -t x sbl.bin| grep KSLCM
  3091c KSLCMBL2VA2M2A
  30968 KSLCMAL2TA0M2A
  7091c KSLCMBL2VA2M2A
  70968 KSLCMAL2TA0M2A
  b091c KSLCMBL2VA2M2A
  b0968 KSLCMAL2TA0M2A
  f091c KSLCMBL2VA2M2A
  f0968 KSLCMAL2TA0M2A
 13091c KSLCMBL2VA2M2A
 130968 KSLCMAL2TA0M2A
└─$ hexdump -C sbl.bin | head -n 10
00000000  d1 dc 4b 84 34 10 d7 73  5a 43 0b 7d ff ff ff ff  |..K.4..sZC.}....|
00000010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00000800  d1 dc 4b 84 34 10 d7 73  5a 43 0b 7d ff ff ff ff  |..K.4..sZC.}....|
00000810  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00001000  d1 dc 4b 84 34 10 d7 73  5a 43 0b 7d ff ff ff ff  |..K.4..sZC.}....|
00001010  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00001800  d1 dc 4b 84 34 10 d7 73  5a 43 0b 7d ff ff ff ff  |..K.4..sZC.}....|
└─$ hexdump -C sbl.bin | tail -n 10
00134370  49 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |I...............|
00134380  00 00 00 00 10 00 48 00  40 22 33 20 00 00 00 00  |......H.@"3 ....|
00134390  00 00 00 00 00 00 00 00  00 00 00 00 88 30 22 00  |.............0".|
001343a0  b0 33 22 00 e8 33 22 00  a8 34 22 00 00 00 00 00  |.3"..3"..4".....|
001343b0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00134700  00 00 00 00 00 00 00 00  00 00 00 00 ff ff ff ff  |................|
00134710  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00140000
```
#### MIBIB
```
└─$ strings -a -t x partition.bin
     10 0:SBL
     2c 0:MIBIB
     48 0:EFS2
     64 0:RAWDATA
     80 0:TZ
     9c 0:RPM
     b8 0:aboot
     d4 0:mnf_info
     f0 0:boot_config
    10c 0:boot_a
    128 0:boot_b
    144 0:modem
    160 0:rootfs_a
    17c 0:rootfs_b
    198 0:storage
└─$ strings -a -t x mibib.bin    
    810 0:SBL
    82c 0:MIBIB
    848 0:EFS2
    864 0:RAWDATA
    880 0:TZ
    89c 0:RPM
    8b8 0:aboot
    8d4 0:mnf_info
    8f0 0:boot_config
    90c 0:boot_a
    928 0:boot_b
    944 0:modem
    960 0:rootfs_a
    97c 0:rootfs_b
    998 0:storage
  e0024 W!.=|,%
```
```
└─$ edl printgpt | awk '/sbl/,0'               
sbl                     00000000        00280000        0xff/0x1/0x0    0
mibib                   00280000        00280000        0xff/0x1/0xff   0
efs2                    00500000        01600000        0xff/0x1/0xff   0
sys_rev                 01B00000        00500000        0xff/0x1/0x0    0
rawdata                 02000000        00300000        0xff/0x1/0x0    0
tz                      02300000        00140000        0xff/0x1/0x0    0
rpm                     02440000        00180000        0xff/0x1/0x0    0
aboot                   025C0000        00140000        0xff/0x1/0x0    0
boot                    02700000        00900000        0xff/0x1/0x0    0
recovery                03000000        00900000        0xff/0x1/0x0    0
image_back              03900000        00640000        0xff/0x1/0x0    0
recoveryfs_b            03F40000        00E00000        0xff/0x1/0x0    0
scrub                   04D40000        01080000        0xff/0x1/0x0    0
modem                   05DC0000        03E00000        0xff/0x1/0x0    0
misc                    09BC0000        00140000        0xff/0x1/0x0    0
recoveryfs              09D00000        01E00000        0xff/0x1/0x0    0
qdsp6sw_b               0BB00000        03800000        0xff/0x1/0x0    0
sys_back                0F300000        03A00000        0xff/0x1/0x0    0
system                  12D00000        0D300000        0xff/0x1/0x0    0
```
#### EFS2
```
└─$ strings -a -t x efs2.bin
  ...
  57dae /nv/item_files/modem/tdscdma/rrc/interrat_feature_ctrl
  57de6 /nv/item_files/modem/tdscdma/rrc/tds_l2_opt_feature_list
  57e20 /nv/item_files/modem/tdscdma/rrc/delay_oos_ind_timer
  57e56 /nv/item_files/modem/tdscdma/rrc/tds_opt_ueci_list
  57e8a /nv/item_files/modem/tdscdma/rrc/sib_sleep_before_sb
  57ec0 /nv/item_files/modem/tdscdma/rrc/sib7_exp_time_factor
  57ef7 /nv/item_files/modem/tdscdma/rrc/silent_redial_opt
  58000 /nv/item_files/modem/tdscdma/rrc/tdsrrc_nv_version
  58034 /nv/item_files/modem/tdscdma/rrc/acq_db
  5805d /nv/item_files/modem/tdscdma/rrc/acq_list
  58088 /nv/item_files/modem/tdscdma/rrc/integrity_enabled
  580bc /nv/item_files/modem/tdscdma/rrc/ciphering_enabled
  580f0 /nv/item_files/modem/tdscdma/rrc/fake_sec_enabled
  58123 /nv/item_files/modem/tdscdma/rrc/special_freq_enabled
  5815a /nv/item_files/modem/tdscdma/rrc/special_freq
  58189 /nv/item_files/modem/tdscdma/rrc/pdcp_disabled
  581b9 /nv/item_files/modem/tdscdma/rrc/tds_rrc_version
  581eb /nv/item_files/modem/tdscdma/rrc/hsdpa_cat
  ...
```
#### RAWDATA
```
└─$ hexdump -C  rawdata.bin
00000000  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00300000
```
#### TZ
```
└─$ binwalk tz.bin 
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             ELF, 32-bit LSB executable, ARM, version 1 (SYSV)
4712          0x1268          Certificate in DER format (x509 v3), header length: 4, sequence length: 1187
5903          0x170F          Certificate in DER format (x509 v3), header length: 4, sequence length: 1027
6934          0x1B16          Certificate in DER format (x509 v3), header length: 4, sequence length: 1063
146392        0x23BD8         Unix path: /dev/icbcfg/tz
377977        0x5C479         XML document, version: "1.0"
378842        0x5C7DA         AES S-Box
379098        0x5C8DA         AES Inverse S-Box
399456        0x61860         SHA256 hash constants, little endian
429911        0x68F57         mcrypt 2.2 encrypted data, algorithm: blowfish-448, mode: CBC, keymode: 4bit
432811        0x69AAB         mcrypt 2.2 encrypted data, algorithm: blowfish-448, mode: CBC, keymode: 4bit
```
#### RPM
```
└─$ binwalk rpm.bin  
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             ELF, 32-bit LSB executable, ARM, version 1 (SYSV)
4520          0x11A8          Certificate in DER format (x509 v3), header length: 4, sequence length: 1187
5711          0x164F          Certificate in DER format (x509 v3), header length: 4, sequence length: 1027
6742          0x1A56          Certificate in DER format (x509 v3), header length: 4, sequence length: 1063
123640        0x1E2F8         Unix path: /dev/icb/rpm
```
#### aboot
```
└─$ binwalk aboot.bin                                                                                          130 ⨯
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             ELF, 32-bit LSB executable, ARM, version 1 (SYSV)
264928        0x40AE0         SHA256 hash constants, little endian
276996        0x43A04         Certificate in DER format (x509 v3), header length: 4, sequence length: 720
278004        0x43DF4         CRC32 polynomial table, little endian
284584        0x457A8         Android bootimg, kernel size: 0 bytes, kernel addr: 0x4F525245, ramdisk size: 1226848850 bytes, ramdisk addr: 0x6C61766E, product name: "ERROR: Invalid boot image pagesize. Device pagesize: %d, Image pagesize: %d"
```
#### mnf_info
```
└─$ hexdump -C  mnf_info.bin 
00000000  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
00000010  31 31 30 30 30 30 30 30  30 30 ff ff ff ff ff ff  |1100000000......| SERIAL
00000020  54 52 42 31 34 30 30 30  58 58 58 58 ff ff ff ff  |TRB14000XXXX....| MODEL
00000030  30 30 30 37 ff ff ff ff  ff ff ff ff ff ff ff ff  |0007............|
00000040  30 32 39 ff ff ff ff ff  ff ff ff ff ff ff ff ff  |029.............|
00000050  30 30 31 30 30 30 30 30  30 30 30 30 ff ff ff ff  |001000000000....| MAC
00000060  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00140000
```
#### boot_config
```
└─$ hexdump -C  boot_config.bin
00000000  53 54 49 54 01 49 44 21  98 30 52 00 00 80 00 80  |STIT.ID!.0R.....|
00000010  00 00 00 00 00 80 00 80  00 00 00 00 00 00 f0 80  |................|
00000020  00 00 e0 81 00 08 00 00  00 68 07 00 00 00 00 00  |.........h......|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000040  6e 6f 69 6e 69 74 72 64  20 20 72 77 20 63 6f 6e  |noinitrd  rw con|
00000050  73 6f 6c 65 3d 74 74 79  48 53 4c 30 2c 31 31 35  |sole=ttyHSL0,115|
00000060  32 30 30 2c 6e 38 20 61  6e 64 72 6f 69 64 62 6f  |200,n8 androidbo|
00000070  6f 74 2e 68 61 72 64 77  61 72 65 3d 71 63 6f 6d  |ot.hardware=qcom|
00000080  20 65 68 63 69 2d 68 63  64 2e 70 61 72 6b 3d 33  | ehci-hcd.park=3|
00000090  20 6d 73 6d 5f 72 74 62  2e 66 69 6c 74 65 72 3d  | msm_rtb.filter=|
000000a0  30 78 33 37 20 6c 70 6d  5f 6c 65 76 65 6c 73 2e  |0x37 lpm_levels.|
000000b0  73 6c 65 65 70 5f 64 69  73 61 62 6c 65 64 3d 31  |sleep_disabled=1|
000000c0  20 20 65 61 72 6c 79 63  6f 6e 3d 6d 73 6d 5f 68  |  earlycon=msm_h|
000000d0  73 6c 5f 75 61 72 74 2c  30 78 37 38 62 33 30 30  |sl_uart,0x78b300|
000000e0  30 20 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |0 ..............|
000000f0  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000240  38 57 72 bc af 78 8a 6f  32 54 aa bd 25 c5 dc 1f  |8Wr..x.o2T..%...|
00000250  a8 6f e3 09 00 00 00 00  00 00 00 00 00 00 00 00  |.o..............|
00000260  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000800  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00140000
```
#### boot_a
```
└─$ hexdump -C  boot_a.bin | head -n 10                                                                        130 ⨯
00000000  41 4e 44 52 4f 49 44 21  e8 fa 55 00 00 80 00 80  |ANDROID!..U.....|
00000010  00 00 00 00 00 80 00 80  00 00 00 00 00 00 f0 80  |................|
00000020  00 00 e0 81 00 08 00 00  00 f0 06 00 00 00 00 00  |................|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000040  6e 6f 69 6e 69 74 72 64  20 63 6f 6e 73 6f 6c 65  |noinitrd console|
00000050  3d 74 74 79 48 53 4c 30  2c 31 31 35 32 30 30 2c  |=ttyHSL0,115200,|
00000060  6e 38 20 65 61 72 6c 79  63 6f 6e 3d 6d 73 6d 5f  |n8 earlycon=msm_|
00000070  68 73 6c 5f 75 61 72 74  2c 30 78 37 38 62 33 30  |hsl_uart,0x78b30|
00000080  30 30 20 65 68 63 69 2d  68 63 64 2e 70 61 72 6b  |00 ehci-hcd.park|
00000090  3d 33 20 6d 73 6d 5f 72  74 62 2e 66 69 6c 74 65  |=3 msm_rtb.filte|
└─$ hexdump -C  boot_a.bin | tail -n 10
005cefc0  61 2d 73 75 70 70 6c 79  00 71 63 61 2c 62 74 2d  |a-supply.qca,bt-|
005cefd0  76 64 64 2d 69 6f 2d 73  75 70 70 6c 79 00 71 63  |vdd-io-supply.qc|
005cefe0  61 2c 62 74 2d 76 64 64  2d 78 74 61 6c 2d 73 75  |a,bt-vdd-xtal-su|
005ceff0  70 70 6c 79 00 71 63 61  2c 62 74 2d 76 64 64 2d  |pply.qca,bt-vdd-|
005cf000  69 6f 2d 76 6f 6c 74 61  67 65 2d 6c 65 76 65 6c  |io-voltage-level|
005cf010  00 71 63 61 2c 62 74 2d  76 64 64 2d 78 74 61 6c  |.qca,bt-vdd-xtal|
005cf020  2d 76 6f 6c 74 61 67 65  2d 6c 65 76 65 6c 00 00  |-voltage-level..|
005cf030  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
005cf800
```
#### boot_b
> Same as boot_a
#### modem
```
└─$ strings  modem.bin | grep "MDM9x07"
/MDM9x07/MCU_R06/modX1m
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_T
mm/MDM9x07/MCU_R06/mWZm_pM@/L
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/mode
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/wolfss
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/mC
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/mL
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/wolfss
%D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/z
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/n
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/wolfssl/src/keys.c
&D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/rfaM
D:/jenkins/Qualcomm/MDM9x07/MCU_R06
$D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/uim/nvr{
/MDM9x07/MCU_R06/
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/"
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/t
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/libwebsocketsu
/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/quectel/libwebsocketsu
        comm/MDM9x07/MCU_R06/modem_P
s/Qualcomm/MDM9x07/MCU_R06/modem_L=
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_H~
m/MDM9x07/MCU_R06/mN
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/qu[
m/MDM9x07/MCU_R06/modem_proc/Y
s/Qualcomm/MDM9x07/MCU_R06/modem_P-
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_\
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/mK
m/MDM9x07/MCU_R06/modem_proc/qu
m/MDM9x07/MCU_R06/modem_P
D:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/o
/MDM9x07/MCU_R06/mU(m
(:/jenkins/Qualcomm/MDM9x07/MCU_R06/modem_proc/rftech_cdma/n
```
#### rootfs_a
```
└─$ binwalk  rootfs_a.bin              
DECIMAL       HEXADECIMAL     DESCRIPTION
--------------------------------------------------------------------------------
0             0x0             UBI erase count header, version: 1, EC: 0x0, VID header offset: 0x800, data offset: 0x1000
```
#### rootfs_b
> Same as rootfs_a
#### storage
```
└─$ hexdump -C  storage.bin | head -n 10
00000000  55 42 49 23 01 00 00 00  00 00 00 00 00 00 00 00  |UBI#............|
00000010  00 00 08 00 00 00 10 00  27 bf 58 31 00 00 00 00  |........'.X1....|
00000020  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
00000030  00 00 00 00 00 00 00 00  00 00 00 00 59 1d d0 87  |............Y...|
00000040  ff ff ff ff ff ff ff ff  ff ff ff ff ff ff ff ff  |................|
*
00000800  55 42 49 21 01 01 00 05  7f ff ef ff 00 00 00 00  |UBI!............|
00000810  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00  |................|
*
00000830  00 00 00 00 00 00 00 00  00 00 00 00 b8 25 64 a8  |.............%d.|
```
### Usefull Links & References:
- [Teltonika SDK](https://wiki.teltonika-networks.com/view/Software_Development_Kit)
- [Quectel Tools](https://www.quectel.com/ProductDownload/EC20.zip)
- [Qualcomm Sahara / Firehose Attack Client / Diag Tools by Bjoern Kerler](https://github.com/bkerler/edl)
- [OpenPST Sahara](https://github.com/openpst/sahara)
- [Firehose Finder by hoplik](https://github.com/hoplik/Firehose-Finder)
