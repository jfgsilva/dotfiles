# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
	PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi
unset rc
alias n=nvim
export FLATPAK_ENABLE_SDK_EXT="node22,golang"
export PATH=$PATH:$HOME/dotfiles/bash-tools

# to install neovide on fedora silverblue follow these instructions
# flatpak install flathub org.freedesktop.Sdk.Extension.node22
# flatpak install flathub org.freedesktop.Sdk.Extension.golang
# flatpak install flathub dev.neovide.neovide
# flatpak override dev.neovide.neovide --filesystem=$HOME/.config/nvim
# mkdir -p ~/.var/app/dev.neovide.neovide/config/
# ln -s ~/.config/nvim ~/.var/app/dev.neovide.neovide/config/nvim

# this allows us to call podman from within toolbox
if [ -n "$TOOLBOX_PATH" ]; then
	export FLATPAK_ENABLE_SDK_EXT="node22,golang"
	alias podman="flatpak-spawn --host podman"
	alias flatpak="flatpak-spawn --host flatpak"
	alias neovide="flatpak-spawn --host flatpak run dev.neovide.neovide"
else
	export FLATPAK_ENABLE_SDK_EXT="node22,golang"
	alias neovide="flatpak run dev.neovide.neovide"
fi

# robbyrussel lookalike for bash
function git_exist_fist() {
	BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]; then
		echo "git:("
	else
		echo ""
	fi
}

function git_exist_last() {
	BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]; then
		echo ")"
	else
		echo ""
	fi
}

# get current branch in git repo
function parse_git_branch() {
	BRANCH=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/')
	if [ ! "${BRANCH}" == "" ]; then
		echo "${BRANCH}"
	else
		echo ""
	fi
}

function parse_git_status() {
	STAT=$(parse_git_dirty)
	if [ ! "${STAT}" == "" ]; then
		STAT=$(parse_git_dirty)
		echo " ✗"
	else
		echo ""
	fi
}

# get current status of git repo
function parse_git_dirty {
	status=$(git status 2>&1 | tee)
	dirty=$(
		echo -n "${status}" 2>/dev/null | grep "modified:" &>/dev/null
		echo "$?"
	)
	untracked=$(
		echo -n "${status}" 2>/dev/null | grep "Untracked files" &>/dev/null
		echo "$?"
	)
	ahead=$(
		echo -n "${status}" 2>/dev/null | grep "Your branch is ahead of" &>/dev/null
		echo "$?"
	)
	newfile=$(
		echo -n "${status}" 2>/dev/null | grep "new file:" &>/dev/null
		echo "$?"
	)
	renamed=$(
		echo -n "${status}" 2>/dev/null | grep "renamed:" &>/dev/null
		echo "$?"
	)
	deleted=$(
		echo -n "${status}" 2>/dev/null | grep "deleted:" &>/dev/null
		echo "$?"
	)
	bits=''
	if [ "${renamed}" == "0" ]; then
		bits=">${bits}"
	fi
	if [ "${ahead}" == "0" ]; then
		bits="*${bits}"
	fi
	if [ "${newfile}" == "0" ]; then
		bits="+${bits}"
	fi
	if [ "${untracked}" == "0" ]; then
		bits="?${bits}"
	fi
	if [ "${deleted}" == "0" ]; then
		bits="x${bits}"
	fi
	if [ "${dirty}" == "0" ]; then
		bits="!${bits}"
	fi
	if [ ! "${bits}" == "" ]; then
		echo " ${bits}"
	else
		echo ""
	fi
}

if [ -n "$TOOLBOX_PATH" ]; then
	export PS1="\[\e[35m\]⬢  \[\e[m\]\[\e[36m\]\w\[\e[m\] \[\e[32m\]\`git_exist_fist\`\[\e[31m\]\`parse_git_branch\`\[\e[32m\]\`git_exist_last\`\[\e[33m\]\`parse_git_status\`\[\e[m\] "
else
	# alias neovide="flatpak run dev.neovide.neovide"
	export PS1="\[\e[32m\]➜  \[\e[m\]\[\e[36m\]\w\[\e[m\] \[\e[32m\]\`git_exist_fist\`\[\e[31m\]\`parse_git_branch\`\[\e[32m\]\`git_exist_last\`\[\e[33m\]\`parse_git_status\`\[\e[m\] "
fi
