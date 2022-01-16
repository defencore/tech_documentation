# Quectel EC25 Firmware Flashing
### EC25-E EC25EFA-512-STD
```
MODEM:             EC25-E EC25EFA-512-STD
FIRMWARE:          EC25EFAR06A01M4G
```
```
HWID:              0x000480e100000000 (MSM_ID:0x000480e1,OEM_ID:0x0000,MODEL_ID:0x0000)
CPU detected:      "MDM9207"
PK_HASH:           0xcc3153a80293939b90d02d3bf8b23e0292e452fef662c74998421adad42a380f
Serial:            0x0cf94c64
```
```
Sec_Boot0 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Sec_Boot1 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Sec_Boot2 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Sec_Boot3 PKHash-Index:0 OEM_PKHash: False Auth_Enabled: False Use_Serial: False
Secure boot disabled.
```
```
Streaming - Base address of the NAND controller: 079b0000
Streaming - Sector size: 516 bytes
Streaming - Spare bytes: 2 bytes
Streaming - Defective block marker position: spare+6
Streaming - The total size of the flash memory = 2048 blocks (512 MB)
Streaming - Flash memory: Toshiba KSLCMBL2VA2M2A, NAND 512MiB 1.8V 8-bit
Streaming - Page size: 4096 bytes (8 sectors)
Streaming - The number of pages in the block: 64
Streaming - OOB size: 256 bytes
Streaming - ECC: BCH, 8 bit
Streaming - ЕСС size: 2 bytes
```
```
Name                    Offset          Length          Attr            Flash       Image
-------------------------------------------------------------------------------------------------------------------------------
sbl                     00000000        00280000        0xff/0x1/0x0    0           sbl1.mbn
mibib                   00280000        00280000        0xff/0x1/0xff   0           partition_complete_p4K_b256K.mbn
efs2                    00500000        01600000        0xff/0x1/0xff   0           
sys_rev                 01B00000        00500000        0xff/0x1/0x0    0           
rawdata                 02000000        00300000        0xff/0x1/0x0    0           
tz                      02300000        00140000        0xff/0x1/0x0    0           tz.mbn
rpm                     02440000        00180000        0xff/0x1/0x0    0           rpm.mbn
aboot                   025C0000        00140000        0xff/0x1/0x0    0           appsboot.mbn
boot                    02700000        00900000        0xff/0x1/0x0    0           mdm9607-perf-boot.img
recovery                03000000        00900000        0xff/0x1/0x0    0           mdm9607-perf-boot.img
image_back              03900000        00640000        0xff/0x1/0x0    0           
recoveryfs_b            03F40000        00E00000        0xff/0x1/0x0    0           mdm-perf-recovery-image-mdm9607-perf.ubi
scrub                   04D40000        01080000        0xff/0x1/0x0    0           
modem                   05DC0000        03E00000        0xff/0x1/0x0    0           NON-HLOS.ubi
misc                    09BC0000        00140000        0xff/0x1/0x0    0           
recoveryfs              09D00000        01E00000        0xff/0x1/0x0    0           mdm-perf-recovery-image-mdm9607-perf.ubi
qdsp6sw_b               0BB00000        03800000        0xff/0x1/0x0    0           NON-HLOS.ubi
sys_back                0F300000        03A00000        0xff/0x1/0x0    0           mdm9607-perf-sysfs.ubi
system                  12D00000        0D300000        0xff/0x1/0x0    0           mdm9607-perf-sysfs.ubi
```
## Flashing with QFirehose

### Native Firmware Structure
```
└─$ tree EC25EFAR06A01M4G
EC25EFAR06A01M4G                                              | Firmware                      | ./QFirehose -n -f ./EC25EFAR06A01M4G
├── contents.xml                                              |                               |
├── md5.txt                                                   | MD5 Hashes                    |
├── Quectel_EC25-E-FA_Firmware_Release_Notes_V0601.pdf        | Release Notes                 |
└── update                                                    |
    ├── appsboot.mbn                                          | Application Bootloader        |
    ├── ENPRG9x07.mbn                                         |
    ├── firehose                                              |
    │   ├── partition_complete_p4K_b256K.mbn                  |
    │   ├── patch_p4K_b256K.xml                               |
    │   ├── prog_nand_firehose_9x07.mbn                       | Firehose programmer           |
    │   └── rawprogram_nand_p4K_b256K_update.xml              | 
    ├── mdm9607-perf-boot.img                                 |
    ├── mdm9607-perf-sysfs.ubi                                |
    ├── mdm-perf-recovery-image-mdm9607-perf.ubi              |
    ├── NON-HLOS.ubi                                          |
    ├── NPRG9x07.mbn                                          |
    ├── partition.mbn                                         |
    ├── partition_nand.xml                                    |
    ├── rpm.mbn                                               | Resource and Power Management |
    ├── sbl1.mbn                                              | Secondary Boot Loader         |
    └── tz.mbn                                                | TrustZone                     |
```
```
└─$ ./rawnand_xml_parse.sh EC25EFAR06A01M4G/update/firehose/rawprogram_nand_p4K_b256K_update.xml
Offset          Length          Image
---------------------------------------------------------------------------
00000000        00280000        ..\sbl1.mbn
00280000        00280000        partition_complete_p4K_b256K.mbn
02300000        00140000        ..\tz.mbn
02440000        00180000        ..\rpm.mbn
025C0000        00140000        ..\appsboot.mbn
02700000        00900000        ..\mdm9607-perf-boot.img
03000000        00900000        ..\mdm9607-perf-boot.img
03F40000        00E00000        ..\mdm-perf-recovery-image-mdm9607-perf.ubi
05DC0000        03E00000        ..\NON-HLOS.ubi
09D00000        01E00000        ..\mdm-perf-recovery-image-mdm9607-perf.ubi
0BB00000        03800000        ..\NON-HLOS.ubi
0F300000        03A00000        ..\mdm9607-perf-sysfs.ubi
12D00000        0D300000        ..\mdm9607-perf-sysfs.ubi
```
```
└─$ ./QFirehose -n -f ./EC25EFAR06A01M4G/
```

### List of abbreviations
```
    PBL   = Primary Boot Loader
    SBL   = Secondary Boot Loader
    RPM   = Resource and Power Management
    TZ    = Trust Zone
    HDLC  = High level Data Link Control
    MSM   = Mobile Station Modem
    DMSS  = Dual Mode Subscriber Station
    QDL   = Qualcomm Download
    QHSUSB_DLOAD = Qualcomm High Speed USB Download
    EhostDL = Emergency Host Download
    DCN   = Document Control Number, used by Qualcomm to track their thousands of documents
    QFIL  = Qualcomm Flash Image Loader
    QPST  = Qualcomm
    EDL   = Emergency Download mode
    HLOS  = High Level OS (Normal boot up mode)
    QFIT  = Qualcomm Factory Image Tools
    ABOOT = Application Bootloader
```

## Links:
- https://forum.openwrt.org/t/help-required-adding-support-for-mdm9607/114244/2



## PARTITION

```
# Only these files are needed to remap the partitions
└─$ tree EC25EFAR06A01M4G
EC25EFAR06A01M4G
└── update
    └── firehose
        ├── partition_complete_p4K_b256K.mbn
        ├── prog_nand_firehose_9x07.mbn
        ├── rawprogram_nand_p4K_b256K_update.xml
        └── sbl1.mbn
└─$ cat EC25EFAR06A01M4G/update/firehose/rawprogram_nand_p4K_b256K_update.xml
<?xml version="1.0" ?>
<data>
  <erase PAGES_PER_BLOCK="64" SECTOR_SIZE_IN_BYTES="4096" num_partition_sectors="640" physical_partition_number="0" start_sector="640"/>
  <program PAGES_PER_BLOCK="64" SECTOR_SIZE_IN_BYTES="4096" filename="partition_complete_p4K_b256K.mbn" num_partition_sectors="640" physical_partition_number="0" start_sector="640"/>
</data>
└─$ ~/development/quectel_ec25eu/QFirehose_Linux_Android_V1.4.8/QFirehose -n -f EC25EFAR06A01M4G
```

## Trying to run OpenWrt
```
# You need to remap the memory using mimib.mbn
Name            Offset          Length          Attr                    Flash
-------------------------------------------------------------
sbl                     00000000        00280000        0xff/0x1/0x0    0
mibib                   00280000        00280000        0xff/0x1/0xff   0
efs2                    00500000        02C00000        0xff/0x1/0xff   0
rawdata                 03100000        00600000        0xff/0x1/0x0    0
tz                      03700000        00280000        0xff/0x1/0x0    0
rpm                     03980000        00280000        0xff/0x1/0x0    0
aboot                   03C00000        00280000        0xff/0x1/0x0    0
mnf_info                03E80000        00280000        0xff/0x1/0x0    0
boot_config             04100000        00280000        0xff/0x1/0x0    0
boot_a                  04380000        01200000        0xff/0x1/0x0    0
boot_b                  05580000        01200000        0xff/0x1/0x0    0
modem                   06780000        07800000        0xff/0x1/0x0    0
rootfs_a                0DF80000        0EE80000        0xff/0x1/0x0    0
rootfs_b                1CE00000        0EE80000        0xff/0x1/0x0    0
storage                 2BC80000        14380000        0xff/0x1/0x0    0
```
```
# We need 2 MIBIB files: from Teltonika TRB140 (trb140_mibib.mbn) and from EC25-E (ec25-e_mibib.mbn)
└─$ strings -a -t x  ec25-e_mibib.mbn
   1010 0:SBL
   102c 0:MIBIB
   1048 0:EFS2
   1064 0:sys_rev
   1080 0:RAWDATA
   109c 0:TZ
   10b8 0:RPM
   10d4 0:aboot
   10f0 0:boot
   110c 0:recovery
   1128 0:image_back
   1144 0:recoveryfs_B
   1160 0:scrub
   117c 0:modem
   1198 0:misc
   11b4 0:recoveryfs
   11d0 0:qdsp6sw_B
   11ec 0:sys_back
   1208 0:rootfs_a
└─$ strings -a -t x trb140_mibib.mbn
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
# We need to patch MIBIB
└─$ dd if=/dev/zero bs=1 count=$((0x300)) |tr "\000" "\377" | dd of=ec25-e_mibib.mbn bs=1 seek=$((0x1000)) conv=notrunc
└─$ dd if=trb140_mibib.mbn bs=1 skip=$((0x800)) count=$((0x300)) | dd of=ec25-e_mibib.mbn bs=1 seek=$((0x1000)) conv=notrunc
```
