set -e

# Do this to the WORK folder of this stage
pushd ${STAGE_WORK_DIR}

log "Install QEMU"

MNT_DIR="${STAGE_WORK_DIR}/mnt"
sudo cp /usr/bin/qemu-arm-static "${MNT_DIR}/usr/bin"

if [ ! -d "linux" ]; then
    log "Download the Raspberry Pi Kernel"
    git clone --depth=100 -b ${PI_KERNEL_BRANCH} ${PI_KERNEL_REPO}
fi

pushd linux
git reset --hard
git pull

# Switch to specific commit
git checkout $GIT_KERNEL_SHA1

# out
popd

log "Download the rtl8812au drivers"
rm -r rtl8812au || true
git clone -b ${RTL_8812AU_BRANCH} ${RTL_8812AU_REPO}

log "Download the v4l2loopback module"
rm -r v4l2loopback || true
git clone -b ${V4L2LOOPBACK_BRANCH} ${V4L2LOOPBACK_REPO}

#return 
popd
