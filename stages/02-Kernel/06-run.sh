set -e


if [[ "${IMAGE_ARCH}" == "jetson" && "${DISTO}" == "xenial" ]]; then

    # Do this to the WORK folder of this stage
    pushd ${STAGE_WORK_DIR}
    MNT_DIR="${STAGE_WORK_DIR}/mnt"

    log "Compile kernel for Jetson"
    pushd ${LINUX_DIR}

    log "Copy Kernel config"
    cp "${STAGE_DIR}/FILES/.config-${KERNEL_BRANCH}-v8a" ./.config || exit 1


    make clean

    #KERNEL=kernel7l ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make bcm2711_defconfig
    yes "" | KERNEL=kernel8a ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make -j $J_CORES zImage modules dtbs

    log "Saving kernel as ${STAGE_WORK_DIR}/kernel8a.img"
    cp arch/arm/boot/zImage "${MNT_DIR}/boot/kernel8a.img" || exit 1

    log "Copy the kernel modules for Jetson"
    make -j $J_CORES ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH="$MNT_DIR" modules_install

    log "Copy the DTBs for Jetson"
    sudo cp arch/arm64/boot/dts/*.dtb "${MNT_DIR}/boot/" || exit 1
    sudo cp arch/arm64/boot/dts/overlays/*.dtb* "${MNT_DIR}/boot/overlays/" || exit 1
    sudo cp arch/arm64/boot/dts/overlays/README "${MNT_DIR}/boot/overlays/" || exit 1

    # out of linux 
    popd

    #return 
    popd


fi
