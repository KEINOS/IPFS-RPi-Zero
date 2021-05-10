#!/bin/bash
# =============================================================================
#  IPFS Node Maintenance Script
# =============================================================================
#  Use this script to connect to your IPFS node admin page via a browser.

MSG_HELP=$(cat << 'EOS'
Usage

  Simply run this script and then open the displayed URL in your browser.
  If success then you will be able to access the WebUI (Admin page).

What It Does

  By default, the IPFS WebUI (Admin page) is restricted to respond only to local
  access. Such as: "http://127.0.0.1:5001" or "http://localhost:5001"

  This means that you can not access from the other machines like:
    "http://raspberrypi.local:5001" or "http://<Your RPi IP address>:5001"

  Thus, you need the OS to be in GUI mode (RaspberryPi OS Desktop) and connect
  a display to the Raspberry Pi just to access the WebUI page. But that is like
  putting the cart before the horse to use Raspberry Pi Zero as a IPFS node.

  This script helps you tunnel that connection to your local machine.

  It simply connects to your Raspberry Pi via SSH and port forwards (tunnels) the
  IPFS' 5001 port in the RaspberryPi Zero to your local host's 5001 port.

EOS
)

# Show Help
echo "$@" | grep help 2>/dev/null 1>/dev/null && {
  echo "$MSG_HELP"
  exit 0
}

# Config
YOUR_RPI_ADDRESS='rpi-ipfs.local' # May be the IP address
USER_SSH_LOGIN='pi'
LOCAL_PORT=5001

# Connect
echo "- URL of IPFS WebUI: http://localhost:${LOCAL_PORT}/webui"
echo "  Connecting to ... ${USER_SSH_LOGIN}@${YOUR_RPI_ADDRESS} (press ctrl+c to disconnect)"
ssh -N "${USER_SSH_LOGIN}@${YOUR_RPI_ADDRESS}" -L "${LOCAL_PORT}:127.0.0.1:5001"
