# OpenWrt SDK
## Prepare Docker Image
```
└─$ docker images
REPOSITORY                 TAG       IMAGE ID       CREATED        SIZE
ubuntu                     xenial    b6f507652425   7 months ago   135MB
└─$ mkdir -p ~/development/github/openwrt/gl.inet/gl-ar750s-ext
└─$ docker run -v ~/development/github/openwrt/gl.inet/gl-ar750s-ext/:/home/openwrt --name openwrt_sdk -it ubuntu:xenial /bin/bash
root@4e1b8336f6ec:/# exit
exit
└─$ docker ps -a
CONTAINER ID   IMAGE           COMMAND       CREATED          STATUS                        PORTS     NAMES
4e1b8336f6ec   ubuntu:xenial   "/bin/bash"   27 seconds ago   Exited (0) 16 seconds ago             openwrt_sdk
└─$ docker stop openwrt_sdk
openwrt_sdk
└─$ docker start openwrt_sdk
openwrt_sdk
└─$ docker ps
CONTAINER ID   IMAGE           COMMAND       CREATED              STATUS        PORTS     NAMES
4e1b8336f6ec   ubuntu:xenial   "/bin/bash"   About a minute ago   Up 1 second             openwrt_sdk
└─$ docker exec -it openwrt_sdk /bin/bash
```

## Install dependencies
```
root@4e1b8336f6ec:/# apt-get update
root@4e1b8336f6ec:/# apt-get upgrade -y
root@4e1b8336f6ec:/# useradd openwrt -b /home -d /home/openwrt -s /bin/bash
root@4e1b8336f6ec:/# apt-get -y install bc libncurses-dev wget rsync nodejs npm jq
root@4e1b8336f6ec:/# apt-get -y install binutils binutils-gold build-essential bzip2 curl device-tree-compiler devscripts file flex fuse g++ gawk gcc gcc-multilib gengetopt gettext git groff libc6-dev libncurses5-dev libpcre3-dev libssl-dev libxml-parser-perl make ocaml ocaml-findlib ocaml-nox patch pkg-config python2.7 python-dev python-yaml sharutils subversion u-boot-tools unzip vim-common wget zlib1g-dev dialog
```

## Prepare OpenWrt SDK
```
openwrt@4e1b8336f6ec:~# su openwrt
openwrt@4e1b8336f6ec:~$ cd ~
openwrt@4e1b8336f6ec:~$ git clone https://git.openwrt.org/openwrt/openwrt.git
openwrt@4e1b8336f6ec:~$ cd openwrt
openwrt@4e1b8336f6ec:~$ git tag -l
v21.02.1
v21.02.2
openwrt@4e1b8336f6ec:~$ git checkout tags/v21.02.2
openwrt@4e1b8336f6ec:~$ ./scripts/feeds update -a
openwrt@4e1b8336f6ec:~$ ./scripts/feeds install -a
```

## Build OpenWrt Base Image for GL.iNet GL-AR750S NOR
```
openwrt@4e1b8336f6ec:~$ make menuconfig
  - Target System (Atheros ATH79)  --->
  - Target Profile (GL.iNet GL-AR750S NOR)  --->
  - Libraries  --->
    - <*> libpcre
openwrt@4e1b8336f6ec:~$ make defconfig
openwrt@4e1b8336f6ec:~$ make menuconfig
openwrt@4e1b8336f6ec:~$ make V=s -j4
```

## Kismet for OpenWrt
```
openwrt@4e1b8336f6ec:~$ cd ~
openwrt@4e1b8336f6ec:~$ mkdir packages
openwrt@4e1b8336f6ec:~$ cd packages
openwrt@4e1b8336f6ec:~$ git clone https://github.com/kismetwireless/kismet-packages.git
openwrt@4e1b8336f6ec:~$ rm -rf ~/openwrt/feeds/packages/net/kismet
openwrt@4e1b8336f6ec:~$ rm -rf ~/openwrt/package/feeds/packages/kismet
openwrt@4e1b8336f6ec:~$ cp -R ~/packages/kismet-packages/openwrt/kismet-openwrt ~/openwrt/package/feeds/packages/
openwrt@4e1b8336f6ec:~$ cd ~/openwrt
openwrt@4e1b8336f6ec:~$ make menuconfig
    - Network  --->
      - kismet  --->
        - <M> kismet
        - <M> kismet-capture-linux-bluetooth
        - <M> kismet-capture-linux-wifi
        - <M> kismet-capture-nrf-51822
        - <M> kismet-capture-nrf-52840
        - <M> kismet-capture-ti-cc2531
        - <M> kismet-capture-ti-cc2540
openwrt@4e1b8336f6ec:~$ make V=s -j$(nproc)
```

## Copy Kismet IPK packages
```
openwrt@4e1b8336f6ec:~$ cd ~
openwrt@4e1b8336f6ec:~$ mkdir packages/ipk
openwrt@4e1b8336f6ec:~$ cp openwrt/bin/packages/mips_24kc/packages/kismet* packages/ipk/
openwrt@4e1b8336f6ec:~$ cp openwrt/bin/packages/mips_24kc/packages/libsqlite3-0_3330000-1_mips_24kc.ipk packages/ipk/
```

## Rebuild OpenWrt Base Image for GL.iNet GL-AR750S NOR/NAND
```
openwrt@4e1b8336f6ec:~$ make menuconfig
  - Target System (Atheros ATH79)  --->
  - Target Profile (GL.iNet GL-AR750S NOR/NAND)  --->
openwrt@4e1b8336f6ec:~$ make V=s -j$(nproc)
```

# GL.Inet GL-AR750S-EXT
## kismet_cap_linux_wifi on GL.Inet GL-AR750S-EXT
```
root@OpenWrt:~# kismet_cap_linux_wifi --connect 192.168.1.254:3501 --tcp --source=wlan0:add_channels="149W5,153W5,157W5,161W5,165W5,151W5,155W5,159W5,163W5,153W5"
root@OpenWrt:~# kismet_cap_linux_wifi --connect 192.168.1.254:3501 --tcp --source=wlan1:add_channels="1W5,2W5,3W5,4W5,5W5,6W5,7W5,8W5,9W5,10W5,11W5,12W5,13W5,14W5"
```

# Ubuntu/Debian Linux
## Kismet
```
└─$ cd ~
└─$ sudo apt install build-essential git libwebsockets-dev pkg-config zlib1g-dev libnl-3-dev libnl-genl-3-dev libcap-dev libpcap-dev libnm-dev libdw-dev libsqlite3-dev libprotobuf-dev libprotobuf-c-dev protobuf-compiler protobuf-c-compiler libsensors4-dev libusb-1.0-0-dev python3 python3-setuptools python3-protobuf python3-requests python3-numpy python3-serial python3-usb python3-dev python3-websockets librtlsdr0 libubertooth-dev libbtbb-dev
└─$ git clone https://github.com/kismetwireless/kismet
└─$ cd kismet
└─$ ./configure
└─$ make
└─$ sudo make install
```
