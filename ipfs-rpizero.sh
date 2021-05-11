#!/bin/bash
# =============================================================================
#  IPFS (Inter-Planetary File System) Installer for Raspberry Pi Zero W
# =============================================================================

# -----------------------------------------------------------------------------
#  IPFS Settings
# -----------------------------------------------------------------------------
# Repo
repo="ipfs/go-ipfs"
version=$(curl --silent "https://api.github.com/repos/${repo}/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
name_file_arch="go-ipfs_${version}_linux-arm.tar.gz"

# App
path_dir_data_ipfs="/ipfs_data"
size_collect_garbage_max=8192

# Env
IPFS_PATH=${IPFS_PATH:-$path_dir_data_ipfs}

export IPFS_PATH="$IPFS_PATH"
export IPFS_FD_MAX="$size_collect_garbage_max"

# -----------------------------------------------------------------------------
#  Uninstall
# -----------------------------------------------------------------------------
echo "$@" | grep 'uninstall' 1>/dev/null 2>/dev/null && {
    echo 'Uninstalling IPFS ...'

    # Remove data dir for IPFS
    echo '- Delete ipfs data dir ...'
    sudo rm --recursive --force "${IPFS_PATH:?Empty path set}"

    # Remove user
    echo '- Delete ipfs user ...'
    sudo userdel --remove ipfs
    sudo groupdel -f ipfs

    # Remove IPFS binary
    which ipfs 1>/dev/null 2>/dev/null && {
        echo '- Delete ipfs app ...'
        sudo rm --force "$(which ipfs)"
    }

    echo '- Done uninstalling ipfs'

    exit
}

# -----------------------------------------------------------------------------
#  Download & Install
# -----------------------------------------------------------------------------
which ipfs 2>/dev/null 1>/dev/null || {
    echo 'Installing IPFS ...'

    # Let fail script when error
    set -eu

    # Move user home
    cd ~/

    # Download archive and checksum file
    echo '- Downloading archive and checksum ...'
    curl -LO "https://github.com/ipfs/go-ipfs/releases/download/${version}/${name_file_arch}"
    curl -LO "https://github.com/ipfs/go-ipfs/releases/download/${version}/${name_file_arch}.sha512"

    # Verify checksum
    echo '- Verifing checksum ...'
    sha512sum --check "${name_file_arch}.sha512"

    # Untar
    echo '- Untar archive ...'
    tar -zxvf "$name_file_arch"

    # Install IPFS
    echo '- Copy IPFS binary ...'
    sudo ./go-ipfs/install.sh
    echo "IPFS installed to: $(which ipfs)"

    # Remove downloaded files
    echo '- Remove downloaded files ...'
    rm --recursive --force ./go-ipfs
    rm --force "$name_file_arch"
    rm --force "${name_file_arch}.sha512"
}

# Smoke test
echo "IPFS Version: $(ipfs --version 2>&1)"

# -----------------------------------------------------------------------------
#  Setup
# -----------------------------------------------------------------------------
echo 'Setup IPFS ...'

# Let fail script when error
set -eu

# Create Data Dir
if [ ! -d "$IPFS_PATH" ]; then
    echo '- Data dir not found. Creating data directory ...'
    sudo mkdir "$IPFS_PATH"
    echo "  Data dir for IPFS: ${IPFS_PATH}"
fi

# Add User
if ! id "ipfs" &>/dev/null; then
    echo '- User "ipfs" not found. Creating user ...'
    sudo adduser --system --group ipfs
    sudo chown -R ipfs:ipfs "$IPFS_PATH"
fi

# Initialize IPFS
path_file_conf_ipfs="${IPFS_PATH}/config"

if [ ! -f "$path_file_conf_ipfs" ]; then
    echo 'Config file for IPFS not found. Intializing IPFS ...'
    echo "* Path Data Dir: ${IPFS_PATH}"
    echo "* Max Size: ${IPFS_FD_MAX}"

    sudo -u ipfs \
        IPFS_PATH="$IPFS_PATH" \
        IPFS_FD_MAX="$IPFS_FD_MAX" \
        ipfs init \
        --algorithm=ed25519 \
        --profile=lowpower,local-discovery,flatfs
fi

echo 'Installation and setup for IPFS done.'

# -----------------------------------------------------------------------------
#  Run IPFS daemon
# -----------------------------------------------------------------------------
echo "$@" | grep 'run' 1>/dev/null 2>/dev/null && {
    echo 'Set max buffer to 1024 MB'
    sudo sysctl -w net.core.rmem_max=2097152

    echo 'Running IPFS daemon ...'
    sudo -u ipfs \
        IPFS_PATH="$IPFS_PATH" \
        IPFS_FD_MAX="$IPFS_FD_MAX" \
        ipfs daemon \
        --migrate \
        --enable-gc &
    # To access IPFS WebUI use SSH port forward as below:
    #   $ ssh -N pi@raspberrypi.local -L 5001:127.0.0.1:5001
}
