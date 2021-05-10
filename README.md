# IPFS Installer for RaspberryPi Zero W

Bash script that installs and setups IPFS for RaspberryPi OS Lite on RaspberryPi Zero W.

- View script: [ipfs-rpizero.sh](./ipfs-rpizero.sh)

## How To Install

1. Get a brand new installed Raspberry Pi OS Lite (with no GUI) micro SD card.
   1. See the prerequisites below.
2. Update, upgrade apk packages and upgrade kernel to the latest as well.
3. SSH to your RaspberryPi Zero W.
4. Go home.
5. Create a file, copy and paste the [script](setup_ipfs.sh).
6. Give access to the script. (`chmod +x ipfs-rpizero.sh`)
7. Run the script. (`./ipfs-rpizero.sh`)
8. Reboot now. (`sudo reboot now`)

### Prerequisites

1. Do not use desktop version of RaspberryPi OS.
1. Set display resolution to 800 x 600 or lower.
1. Change host name from `raspberrypi` to other, if necessary. (Recommended though)
1. Set disk swap size to 2GB.
1. Change your `pi` user password.
1. Set SSH settings to login with private key. (Send your public key to `~/.ssh/known_hosts`)
1. Disable SSH pasword login and root user login.
1. Disable all exposed ports except: SSH(22) and IPFS(4001).

## How To Run IPFS Daemon

- `./ipfs-rpizero.sh run`

## How To Uninstall

- `./ipfs-rpizero.sh uninstall`

## How To Check Status of IPFS Daemon (Access to IPFS Web UI)

- `./run-webui.sh`

IPFS Daemon contains a built-in Web server to monitor the status from the Web browser.

You can monitor file trafic, peers connected and post or mange a file to IPFS.

Though, this script does not allow Web access from other client. (Only `http://localhost:5001/` or `http://127.0.0.1:5001` request are allowed)

We recommend to SSH port forward the `127.0.0.0:5001` access of your rpi to your local.

```bash
# In your local, run the below to begin port forward/tunnel the SSH access.
ssh -N pi@raspberrypi.local -L 5001:127.0.0.1:5001

# Note that the above login user is `pi` and the host is `raspberrypi.local`.
# Change it to your settings.
```

Then from your browser, access: `http://localhost:5001/webui`

## How To Contribute

- Request, enhancement, ideas, etc. -> Go to the discussions
- Bug report -> Go to the issues
- PR -> Welcome!!
  - We recommend to draft a PR first, before implementing anything. So the others would know what you are dealing with.

## Resources

- In Japanese
  - [ヘッドレス RaspberryPi ZeroW のブートディスク作成（Wi-Fi 設定済み SSH 有効済み）と設定](https://qiita.com/KEINOS/items/43394e4bd3c8fcfb5ee8) @ Qiita
  - [ハッシュ関数と次世代ファイルシステム IPFS の関係](https://qiita.com/KEINOS/items/c92268386d265042ea16#%E3%83%8F%E3%83%83%E3%82%B7%E3%83%A5%E9%96%A2%E6%95%B0%E3%81%A8%E6%AC%A1%E4%B8%96%E4%BB%A3%E3%83%95%E3%82%A1%E3%82%A4%E3%83%AB%E3%82%B7%E3%82%B9%E3%83%86%E3%83%A0-ipfs-%E3%81%AE%E9%96%A2%E4%BF%82) | hashアルゴリズムとハッシュ値の長さ一覧（＋ハッシュ関数の基本と応用） @ Qiita

## Tested Environments

```shellscript
$ # OS
$ cat /etc/os-release | grep PRETTY_NAME
PRETTY_NAME="Raspbian GNU/Linux 10 (buster)"

$ # Hardware Revision
$ cat /proc/device-tree/model
Raspberry Pi Zero W Rev 1.1

$ # Kernel version
$ cat /proc/version
Linux version 5.10.31+ (dom@buildbot) (arm-linux-gnueabihf-gcc-8 (Ubuntu/Linaro 8.4.0-3ubuntu1) 8.4.0, GNU ld (GNU Binutils for Ubuntu) 2.34) #1412 Wed Apr 21 15:43:03 BST 2021

$ # IPFS version
$ sudo -u ipfs ipfs --version
ipfs version 0.8.0

```

## ToDo

- [ ] Create systemd service template
- [ ] Create tests for script `setup_ipfs.sh` (Lint and static analysis check)
- [ ] Include basic security checker.
  - [ ] `pi` user password is not default (not `raspberry`)
  - [ ] ssh: pasword login is disabled
  - [ ] ssh: root uer login is disabled
- [ ] Reboot machine periodically (`cron` once a `n`th day)
- [ ] Check IPFS latest stable version on boot
