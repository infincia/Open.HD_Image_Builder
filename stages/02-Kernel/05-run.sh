set -e

if [[ "${IMAGE_ARCH}" == "amd64" && "${DISTO}" == "bionic" ]]; then

    # Do this to the WORK folder of this stage
    pushd ${STAGE_WORK_DIR}
    MNT_DIR="${STAGE_WORK_DIR}/mnt"

    log "Compile kernel for amd64"
    pushd ${LINUX_DIR}

    log "Copy Kernel config"
    cp "${STAGE_DIR}/FILES/.config-${KERNEL_BRANCH}-amd64" ./.config || exit 1


    make clean

    yes "" | make -j $J_CORES zImage modules dtbs

    log "Saving kernel as ${STAGE_WORK_DIR}/kernelamd64.img"
    cp arch/amd64/boot/zImage "${MNT_DIR}/boot/kernelamd64.img" || exit 1

    log "Copy the kernel modules for amd64"
    make -j $J_CORES INSTALL_MOD_PATH="$MNT_DIR" modules_install

    # out of linux 
    popd

    #return 
    popd


fi
