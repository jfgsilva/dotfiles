#!/bin/bash

# This file should be executed just after cloning this repository

# Pre-requisites
PR="git make unzip gcc ripgrep neovim"

SCRIPT_DIR=$(dirname "$(realpath "$0")")

# Setup environment variables
export XDG_CONFIG_HOME="$HOME"/.config

echo "Would you like to perform a full run or just a config update? (full/config)"
read -r USER_CHOICE

# Function to clone or update a git repository
manage_repo() {
  local REPO_URL=$1
  local REPO_DIR=$2

  if [ -d "$REPO_DIR/.git" ]; then
    echo "Repository already exists at $REPO_DIR. Performing git pull."
    git -C "$REPO_DIR" pull
  else
    echo "Cloning repository from $REPO_URL to $REPO_DIR."
    git clone "$REPO_URL" "$REPO_DIR"
  fi
}

if [ "$USER_CHOICE" = "full" ]; then
  echo "Installing requirements"

  # Detect package manager and install prerequisites
  if command -v dnf >/dev/null 2>&1; then
      sudo dnf install "$PR fd-find"
  elif command -v apt-get >/dev/null 2>&1; then
      sudo apt update
      sudo apt install "$PR xclip"
  elif command -v brew >/dev/null 2>&1; then
      brew install $PR
  else
      echo "No supported package manager found. Please install the prerequisites manually: $PR"
      exit 1
  fi

  # Get the directory where the script is located
  SCRIPT_DIR=$(dirname "$(realpath "$0")")

  # Setup environment variables
  export XDG_CONFIG_HOME="$HOME"/.config

  echo "Creating directories"
  # Create directories
  mkdir -p "$XDG_CONFIG_HOME"/tmux
  mkdir -p "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins

  echo "Setting up repositories"
  manage_repo "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
  tmux source "$XDG_CONFIG_HOME"/tmux/tmux.conf

  # Neovim
  manage_repo "https://github.com/jfgsilva/kickstart.nvim.git" "${XDG_CONFIG_HOME}"/nvim
fi

if [ "$USER_CHOICE" = "full" ] || [ "$USER_CHOICE" = "config" ]; then
  echo "Cleaning up nvim custom plugins"
  rm "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/*

  # Symbolic links
  echo "Creating symlinks"

  ln -sf "$SCRIPT_DIR/tmux.conf" "$XDG_CONFIG_HOME"/tmux/tmux.conf
  ln -sf "$SCRIPT_DIR/nvim-plugins/oil.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/oil.lua
  ln -sf "$SCRIPT_DIR/nvim-plugins/mini-icons.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/mini-icons.lua
  ln -sf "$SCRIPT_DIR/nvim-plugins/init.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/init.lua
  ln -sf "$SCRIPT_DIR/nvim-plugins/nvim-dap.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/
  ln -sf "$SCRIPT_DIR/nvim-plugins/yaml-lsp.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/
  ln -sf "$SCRIPT_DIR/nvim-plugins/lua-line.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/
  ln -sf "$SCRIPT_DIR/nvim-plugins/jfs_configs.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/
  ln -sf "$SCRIPT_DIR/nvim-plugins/harpoon.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/
fi

echo "Operation completed."

