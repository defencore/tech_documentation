```
# Disable DroneID Broadcasts except the serial number, it will be replaced with "fakefake"
└─$ echo '55 12 04 c7 2a c3 02 00 40 03 da 05 00 00 00 00 3f 76' | xxd -r -p > /dev/ttyACM0

# Enable DroneID Broadcasts
└─$ echo '55 12 04 c7 2a c3 02 00 40 03 da 05 ff 00 00 00 3f 76' | xxd -r -p > /dev/ttyACM0
```

```
# Get DroneID Status
└─$ cat /dev/ttyACM0 | xxd -pu | tr -d '\n' | sed 's/^.*551304/551304/g' | grep '551304' | tr a-z A-Z | cut -c27-28
```

References:
- https://github.com/MAVProxyUser/CIAJeepDoors/blob/main/CIAJeepdoors_1.2/CIAJeepDoors.py
