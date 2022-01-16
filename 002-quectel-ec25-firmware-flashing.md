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
Name                    Offset          Length          Attr            Flash
-----------------------------------------------------------------------------
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
## Flashing with QFirehose

### Native Firmware Structure
```
└─$ tree EC25EFAR06A01M4G
EC25EFAR06A01M4G                                              | Firmware 
├── contents.xml                                              | 
├── md5.txt                                                   | MD5 Hashes
├── Quectel_EC25-E-FA_Firmware_Release_Notes_V0601.pdf        | Release Notes
└── update                                                    |
    ├── appsboot.mbn                                          | Application Bootloader
    ├── ENPRG9x07.mbn                                         |
    ├── firehose                                              |
    │   ├── partition_complete_p4K_b256K.mbn                  |
    │   ├── patch_p4K_b256K.xml                               |
    │   ├── prog_nand_firehose_9x07.mbn                       | Firehose programmer
    │   └── rawprogram_nand_p4K_b256K_update.xml              | 
    ├── mdm9607-perf-boot.img                                 |
    ├── mdm9607-perf-sysfs.ubi                                |
    ├── mdm-perf-recovery-image-mdm9607-perf.ubi              |
    ├── NON-HLOS.ubi                                          |
    ├── NPRG9x07.mbn                                          |
    ├── partition.mbn                                         |
    ├── partition_nand.xml                                    |
    ├── rpm.mbn                                               | Resource and Power Management
    ├── sbl1.mbn                                              | Secondary Boot Loader
    └── tz.mbn                                                | TrustZone
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
