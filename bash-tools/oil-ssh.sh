#!/bin/sh

# This script is used to easily open an SSH connection through the Neovim Oil file manager.
# Before using this script you need to make it executable with `$ chmod +x oil-ssh.sh`.
# Usage: `$ ./oil-ssh.sh` (or `$ oil` with an alias)
# NOTE: Don t forget to add the following line in .zshrc and add this file to path
# alias oil='~/bin/oil-ssh.sh'

# NOTE: Requirements
# Also install fzf
#
# Select a host via fzf
host=$(grep 'Host\>' ~/.ssh/config | sed 's/^Host //' | grep -v '\*' | fzf --cycle --layout=reverse)

if [ -z "$host" ]; then
	exit 0
fi

# Get user from host name
user=$(ssh -G "$host" | grep '^user\>'  | sed 's/^user //')

nvim oil-ssh://"$user"@"$host"/

