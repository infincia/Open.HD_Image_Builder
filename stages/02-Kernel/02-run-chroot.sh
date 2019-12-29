# This runs in context if the image (CHROOT)
# Any native compilation can be done here
# Do not use log here, it will end up in the image

#!/bin/bash

apt install flex bison libelf-dev systemtap-sdt-dev libaudit-dev libslang2-dev liblzma-dev libdw-dev libunwind-dev binutils-dev

pushd /home/pi/linux/tools/perf
make clean
make
cp ./perf /usr/bin/perf_4.14
popd

umount /home/pi/linux
