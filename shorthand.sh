#!/bin/bash

# Since `ipfs` command is restricted to user "ipfs", use this alias
# for your convenience.
# (place it in your bash config: .bashrc or .bash_profile)
alias ipfs='sudo -u ipfs IPFS_PATH="$IPFS_PATH" ipfs'
