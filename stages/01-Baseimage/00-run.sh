# Do this to the WORK folder of this stage
pushd ${STAGE_WORK_DIR}

log "Check any previous images"

if [[ "${IMAGE_ARCH}" == "pi" ]]; then
    COMPRESSED_IMAGE="${BASE_IMAGE}.zip"
elif [[ "${IMAGE_ARCH}" == "amd64" ]]; then
    COMPRESSED_IMAGE="${BASE_IMAGE}.tar.gz"
elif [[ "${IMAGE_ARCH}" == "jetson" ]]; then
    COMPRESSED_IMAGE="${BASE_IMAGE}.zip"
fi

# check for matching sha256 hash instead of downloading it again
if [[ -f "${COMPRESSED_IMAGE}" ]]; then
    rm *.img || true # must be deleted every time because of no way to check
    log "Base Image already downloaded"
else
    rm *.zip || true
    rm *.tar.gz || true
    rm *.img || true

    log "Download base Image"
    wget ${BASE_IMAGE_URL}/${COMPRESSED_IMAGE}
fi


if [[ "${IMAGE_ARCH}" == "pi" ]]; then
    log "Unzip pi"
    unzip "${COMPRESSED_IMAGE}"
fi

if [[ "${IMAGE_ARCH}" == "jetson" ]]; then
    log "Unzip jetson"
    unzip "${COMPRESSED_IMAGE}"
    mv "sd-blob-b01.img" "${BASE_IMAGE}.img"
fi

if [[ "${IMAGE_ARCH}" == "amd64" ]]; then
    log "Untar amd64"
    tar xf "${COMPRESSED_IMAGE}"
    mv "${BASE_IMAGE}/${BASE_IMAGE}.img" "${BASE_IMAGE}.img"
fi

log "Rename to IMAGE.img"
mv "${BASE_IMAGE}.img" IMAGE.img

# return
popd


