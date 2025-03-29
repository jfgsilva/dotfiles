# Fedora silverblue qol tips
## enable flathub
```bash
# enable flathub
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
# setup firefox flathub with 1password
flatpak install flathub org.mozilla.firefox
flatpak install https://downloads.1password.com/linux/flatpak/1Password.flatpakref
mkdir -p ~/.ssh
chmod 700 ~/.ssh
find ~/.ssh -type f -exec chmod 600 {} \;:W
# TODO: meter docker pull a imagem que quero, instalar a toolbox e ir a partir dadoc
podman pull gavsilva/toolbelt:f41-base
toolbox create --image docker.io/toolbelt:f41-base base
# installing op on toolbox
sudo rpm --import https://downloads.1password.com/linux/keys/1password.asc
sudo sh -c 'echo -e "[1password]\nname=1Password Stable Channel\nbaseurl=https://downloads.1password.com/linux/rpm/stable/\$basearch\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=\"https://downloads.1password.com/linux/keys/1password.asc\"" > /etc/yum.repos.d/1password.repo'
sudo dnf check-update -y 1password-cli && sudo dnf install 1password-cli
# add any relevant ssh keys
 


My dotfiles

# stow
##

# tmux
## install tmux plugin manager k

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
# type this in terminal if tmux is already running
tmux source-file ~/.tmux.conf
# maybe tmux source ~/.tmux.conf
# now type leader + I to install plugins
```

# neovim
## installing kickstart
git clone git@github.com:jfgsilva/kickstart.nvim.git "${XDG_CONFIG_HOME:-$HOME/.config}"/nvim

# zsh
## decrypting zsh_secrets.gpg
```bash
# encrypting
gpg --symmetric --cipher-algo AES256 ~/.zsh_secrets
# decrypting
gpg --quiet --decrypt ~/.zsh_secrets.gpg ~/.zsh_secrets
```

# gitconfig
Have a look at the following youtube talk [so you think you know git](https://www.youtube.com/watch?v=aolI_Rz0ZqY&t=2224s)
## some basic configuration
[gist](https://gist.github.com/schacon)
## better branch script
```bash
#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NO_COLOR='\033[0m'
BLUE='\033[0;34m'
YELLOW='\033[0;33m'
NO_COLOR='\033[0m'

width1=5
width2=6
width3=30
width4=20 2
width5=40

# Function to count commits
count_commits() {
    local branch="$1"
    local base_branch="$2"
    local ahead_behind

    ahead_behind=$(git rev-list --left-right --count "$base_branch"..."$branch")
    echo "$ahead_behind"
}

# Main script
main_branch=$(git rev-parse HEAD)

printf "${GREEN}%-${width1}s ${RED}%-${width2}s ${BLUE}%-${width3}s ${YELLOW}%-${width4}s ${NO_COLOR}%-${width5}s\n" "Ahead" "Behind" "Branch" "Last Commit"  " "

# Separator line for clarity
printf "${GREEN}%-${width1}s ${RED}%-${width2}s ${BLUE}%-${width3}s ${YELLOW}%-${width4}s ${NO_COLOR}%-${width5}s\n" "-----" "------" "------------------------------" "-------------------" " "


format_string="%(objectname:short)@%(refname:short)@%(committerdate:relative)"
IFS=$'\n'

for branchdata in $(git for-each-ref --sort=-authordate --format="$format_string" refs/heads/ --no-merged); do
    sha=$(echo "$branchdata" | cut -d '@' -f1)
    branch=$(echo "$branchdata" | cut -d '@' -f2)
    time=$(echo "$branchdata" | cut -d '@' -f3)
    if [ "$branch" != "$main_branch" ]; then
            # Get branch description
            description=$(git config branch."$branch".description)
            
            # Count commits ahead and behind
            ahead_behind=$(count_commits "$sha" "$main_branch")
            ahead=$(echo "$ahead_behind" | cut -f2)
            behind=$(echo "$ahead_behind" | cut -f1)
            
            # Display branch info
	    printf "${GREEN}%-${width1}s ${RED}%-${width2}s ${BLUE}%-${width3}s ${YELLOW}%-${width4}s ${NO_COLOR}%-${width5}s\n" $ahead $behind $branch "$time" "$description"
    fi
done


```

# old but goodies
## git blame
```bash
# git blame just a little
git blame -L 15,26 path/to/file
# ignore white space and ignore movement
git blame -w -C
```

## git log
```bash
# git log just a little
git log -L 15,26 path/to/file
```

## pickaxe
```bash
# It's useful for tracking when and where a particular string or code snippet was introduced or removed.
git log -S files_watcher -p
```
## diff
```bash
# find changes on lines word per word
git diff --word-diff
```

## record fixing automatically for future cases
```bash
git config --global rerere.enabled true
```

## push
```bash
# only force push if someone didn t push something first
git push --force-with-lease
```

## git maintenance
```bash
git maintenance start
```
