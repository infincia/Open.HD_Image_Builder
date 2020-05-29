# Do this to the WORK folder of this stage
pushd ${STAGE_WORK_DIR}


# in Make file change CONFIG_PLATFORM_I386_PC = y -> n, CONFIG_PLATFORM_ARM_RPI = n -> y and TopDir

cd rtl8812au
if [ "$IMAGE_ARCH" == "pi" || "$IMAGE_ARCH" == "jetson" ]; then
    sudo sed -i 's/CONFIG_PLATFORM_I386_PC = y/CONFIG_PLATFORM_I386_PC = n/' Makefile
    sudo sed -i 's/CONFIG_PLATFORM_ARM_RPI = n/CONFIG_PLATFORM_ARM_RPI = y/' Makefile
fi
# per justins request commented out
# sudo sed -i 's/CONFIG_USB2_EXTERNAL_POWER = n/CONFIG_USB2_EXTERNAL_POWER = y/' Makefile
sudo sed -i 's/export TopDIR ?= $(shell pwd)/export TopDIR2 ?= $(shell pwd)/' Makefile
sudo sed -i '/export TopDIR2 ?= $(shell pwd)/a export TopDIR := $(TopDIR2)/drivers/net/wireless/realtek/rtl8812au/' Makefile

# Change the STBC value to make all antennas send with awus036ACH

cd core
sudo sed -i 's/u8 fixed_rate = MGN_1M, sgi = 0, bwidth = 0, ldpc = 0, stbc = 0;/u8 fixed_rate = MGN_1M, sgi = 0, bwidth = 0, ldpc = 0, stbc = 1;/' rtw_xmit.c
cd ..

cd ..

log "Merge the RTL8812 driver into kernel"

cp -a rtl8812au/. ${LINUX_DIR}/drivers/net/wireless/realtek/rtl8812au/

log "Copy v4l2loopback driver into kernel"
cp -a v4l2loopback/. ${LINUX_DIR}/drivers/media/v4l2loopback/

#return 
popd
