set -e

if [[ "${IMAGE_ARCH}" == "pi" ]]; then

    # Do this to the WORK folder of this stage
    pushd ${STAGE_WORK_DIR}
    MNT_DIR="${STAGE_WORK_DIR}/mnt"

    log "Compile kernel For Pi 1, Pi Zero, Pi Zero W, or Compute Module"
    pushd ${LINUX_DIR}

    log "Copy Kernel config"
    cp "${STAGE_DIR}/FILES/.config-${KERNEL_BRANCH}-v6" ./.config || exit 1


    make clean

    #KERNEL=kernel ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make bcmrpi_defconfig
    yes "" | KERNEL=kernel ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- make -j $J_CORES zImage modules dtbs

    log "Saving kernel as ${STAGE_WORK_DIR}/kernel1.img"
    cp arch/arm/boot/zImage "${MNT_DIR}/boot/kernel.img" || exit 1

    log "Copy the kernel modules For Pi 1, Pi Zero, Pi Zero W, or Compute Module"
    make -j $J_CORES ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- INSTALL_MOD_PATH="$MNT_DIR" modules_install

    log "Copy the DTBs For Pi 1, Pi Zero, Pi Zero W, or Compute Module"
    sudo cp arch/arm/boot/dts/*.dtb "${MNT_DIR}/boot/" || exit 1
    sudo cp arch/arm/boot/dts/overlays/*.dtb* "${MNT_DIR}/boot/overlays/" || exit 1
    sudo cp arch/arm/boot/dts/overlays/README "${MNT_DIR}/boot/overlays/" || exit 1

    # out of linux source dir
    popd

    #return 
    popd

fi
