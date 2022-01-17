# MDM9x07 MEMORY REMAP

For memory remap we need Qualcomm MIBIB partitioning file for your device:

- partition_complete_p4K_b256K.mbn from `EC25-E  EC25EFA-512-STD`
- partition_complete_p2K_b128K.mbn from `EC25-EU EC25EUGA-512-SGNS`
- or dump it using `edl r mibib mibib.bin`

## partition_complete_p2K_b128K.mbn
```
# Offsets for NAND with 2048 bytes page
└─$ strings -a -t x partition_complete_p2K_b128K.mbn
    810 0:SBL
    82c 0:MIBIB
    848 0:EFS2
    864 0:sys_rev
    880 0:RAWDATA
    89c 0:cust_info
    8b8 0:oemapp
    8d4 0:TZ
    8f0 0:RPM
    90c 0:aboot
    928 0:boot
    944 0:recovery
    960 0:image_back
    97c 0:recoveryfs_B
    998 0:scrub
    9b4 0:modem
    9d0 0:misc
    9ec 0:recoveryfs
    a08 0:qdsp6sw_B
    a24 0:sys_back
    a40 0:system
# Partitions count
└─$ strings -a -t x partition_complete_p2K_b128K.mbn | wc -l
21
```
```
└─$ xxd -s $((0x810)) -l $(((0x82c-0x810)*21)) -c $((0x82c-0x810)) partition_complete_p2K_b128K.mbn
00000810: 303a 5342 4c00 0000 0000 0000 0000 0000 0000 0000 0a00 0000 ff01 0000  0:SBL.......................
0000082c: 303a 4d49 4249 4200 0000 0000 0000 0000 0a00 0000 0a00 0000 ff01 ff00  0:MIBIB.....................
00000848: 303a 4546 5332 0000 0000 0000 0000 0000 1400 0000 b000 0000 ff01 ff00  0:EFS2......................
00000864: 303a 7379 735f 7265 7600 0000 0000 0000 c400 0000 2800 0000 ff01 0000  0:sys_rev...........(.......
00000880: 303a 5241 5744 4154 4100 0000 0000 0000 ec00 0000 1800 0000 ff01 0000  0:RAWDATA...................
0000089c: 303a 6375 7374 5f69 6e66 6f00 0000 0000 0401 0000 0e00 0000 ff01 0000  0:cust_info.................
000008b8: 303a 6f65 6d61 7070 0000 0000 0000 0000 1201 0000 1800 0000 ff01 0000  0:oemapp....................
000008d4: 303a 545a 0000 0000 0000 0000 0000 0000 2a01 0000 0a00 0000 ff01 0000  0:TZ............*...........
000008f0: 303a 5250 4d00 0000 0000 0000 0000 0000 3401 0000 0a00 0000 ff01 0000  0:RPM...........4...........
0000090c: 303a 6162 6f6f 7400 0000 0000 0000 0000 3e01 0000 0a00 0000 ff01 0000  0:aboot.........>...........
00000928: 303a 626f 6f74 0000 0000 0000 0000 0000 4801 0000 4800 0000 ff01 0000  0:boot..........H...H.......
00000944: 303a 7265 636f 7665 7279 0000 0000 0000 9001 0000 4800 0000 ff01 0000  0:recovery..........H.......
00000960: 303a 696d 6167 655f 6261 636b 0000 0000 d801 0000 0a00 0000 ff01 0000  0:image_back................
0000097c: 303a 7265 636f 7665 7279 6673 5f42 0000 e201 0000 7000 0000 ff01 0000  0:recoveryfs_B......p.......
00000998: 303a 7363 7275 6200 0000 0000 0000 0000 5202 0000 8200 0000 ff01 0000  0:scrub.........R...........
000009b4: 303a 6d6f 6465 6d00 0000 0000 0000 0000 d402 0000 f001 0000 ff01 0000  0:modem.....................
000009d0: 303a 6d69 7363 0000 0000 0000 0000 0000 c404 0000 0a00 0000 ff01 0000  0:misc......................
000009ec: 303a 7265 636f 7665 7279 6673 0000 0000 ce04 0000 f000 0000 ff01 0000  0:recoveryfs................
00000a08: 303a 7164 7370 3673 775f 4200 0000 0000 be05 0000 c001 0000 ff01 0000  0:qdsp6sw_B.................
00000a24: 303a 7379 735f 6261 636b 0000 0000 0000 7e07 0000 d001 0000 ff01 0000  0:sys_back......~...........
00000a40: 303a 7379 7374 656d 0000 0000 0000 0000 4e09 0000 b206 0000 ff01 0000  0:system........N...........
```

## partition_complete_p4K_b256K.mbn
```
# Offsets for NAND with 4096 bytes page
└─$ strings -a -t x partition_complete_p4K_b256K.mbn 
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
   1208 0:system
```
```
└─$ xxd -s $((0x1010)) -l $((28*19)) -c 28 partition_complete_p4K_b256K.mbn
00001010: 303a 5342 4c00 0000 0000 0000 0000 0000 0000 0000 0a00 0000 ff01 0000  0:SBL.......................
0000102c: 303a 4d49 4249 4200 0000 0000 0000 0000 0a00 0000 0a00 0000 ff01 ff00  0:MIBIB.....................
00001048: 303a 4546 5332 0000 0000 0000 0000 0000 1400 0000 5800 0000 ff01 ff00  0:EFS2..............X.......
00001064: 303a 7379 735f 7265 7600 0000 0000 0000 6c00 0000 1400 0000 ff01 0000  0:sys_rev.......l...........
00001080: 303a 5241 5744 4154 4100 0000 0000 0000 8000 0000 0c00 0000 ff01 0000  0:RAWDATA...................
0000109c: 303a 545a 0000 0000 0000 0000 0000 0000 8c00 0000 0500 0000 ff01 0000  0:TZ........................
000010b8: 303a 5250 4d00 0000 0000 0000 0000 0000 9100 0000 0600 0000 ff01 0000  0:RPM.......................
000010d4: 303a 6162 6f6f 7400 0000 0000 0000 0000 9700 0000 0500 0000 ff01 0000  0:aboot.....................
000010f0: 303a 626f 6f74 0000 0000 0000 0000 0000 9c00 0000 2400 0000 ff01 0000  0:boot..............$.......
0000110c: 303a 7265 636f 7665 7279 0000 0000 0000 c000 0000 2400 0000 ff01 0000  0:recovery..........$.......
00001128: 303a 696d 6167 655f 6261 636b 0000 0000 e400 0000 1900 0000 ff01 0000  0:image_back................
00001144: 303a 7265 636f 7665 7279 6673 5f42 0000 fd00 0000 3800 0000 ff01 0000  0:recoveryfs_B......8.......
00001160: 303a 7363 7275 6200 0000 0000 0000 0000 3501 0000 4200 0000 ff01 0000  0:scrub.........5...B.......
0000117c: 303a 6d6f 6465 6d00 0000 0000 0000 0000 7701 0000 f800 0000 ff01 0000  0:modem.........w...........
00001198: 303a 6d69 7363 0000 0000 0000 0000 0000 6f02 0000 0500 0000 ff01 0000  0:misc..........o...........
000011b4: 303a 7265 636f 7665 7279 6673 0000 0000 7402 0000 7800 0000 ff01 0000  0:recoveryfs....t...x.......
000011d0: 303a 7164 7370 3673 775f 4200 0000 0000 ec02 0000 e000 0000 ff01 0000  0:qdsp6sw_B.................
000011ec: 303a 7379 735f 6261 636b 0000 0000 0000 cc03 0000 e800 0000 ff01 0000  0:sys_back..................
00001208: 303a 7379 7374 656d 0000 0000 0000 0000 b404 0000 4c03 0000 ff01 0000  0:system............L.......
          │    │                                  │         │         │
          │    │                                  │         │         └───────── Attr
          │    │                                  │         │                    Page size: 4096 bytes
          │    │                                  │         │                    The number of pages in the block: 64
          │    │                                  │         └─────────────────── Length = Length/4096*64
          │    │                                  └───────────────────────────── Offset = Offset/4096*64
          │    └──────────────────────────────────────────────────────────────── Partition Name
          └───────────────────────────────────────────────────────────────────── Flash
```
### Example
```
└─$ printf '0:system' | xxd 
00000000: 303a 7379 7374 656d                      0:system
```

### How to calculate 0:system Length & Offset from MIBIB
```
└─$  for A in $(printf %08X'\n' $((0x0D300000/(4096*64))) ); do echo $A | grep -o .. | tac | tr -d '\n'; done
4C030000 # Length
└─$  for A in $(printf %08X'\n' $((0x12D00000/(4096*64))) ); do echo $A | grep -o .. | tac | tr -d '\n'; done
B4040000 # Offset
```

### How to calculate 0:system Length & Offset for MIBIB
```
└─$ printf %08x $(($(echo 0x$(for A in $(printf %08X'\n' $((0xB4040000)) ); do echo $A | grep -o .. | tac | tr -d '\n'; done))*4096*64)
12d00000 # Length
└─$ printf %08x $(($(echo 0x$(for A in $(printf %08X'\n' $((0x4c030000)) ); do echo $A | grep -o .. | tac | tr -d '\n'; done))*4096*64))
0d300000 # Offset
```
### EC25-E EC25EFA-512-STD Partition Table
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
## BEFORE
![image](https://user-images.githubusercontent.com/56395503/149693681-6716fb46-4a1b-4584-b67f-e9ea34d8290c.png)

## AFTER
