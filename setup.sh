# This file should be executed just after cloning this repository

# pre requisites
PR="git make unzip gcc ripgrep neovim"

echo "Installing requirements"

# Detect package manager and install prerequisites
if command -v dnf >/dev/null 2>&1; then
    sudo dnf install  "$PR fd-find"
elif command -v apt-get >/dev/null 2>&1; then
    sudo apt update
    sudo apt install  "$PR xclip"
elif command -v brew >/dev/null 2>&1; then
    brew install $PR
else
    echo "No supported package manager found. Please install the prerequisites manually: $PR"
    exit 1
fi

# Get the directory where the script is located
SCRIPT_DIR=$(dirname "$(realpath "$0")")

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


# setup environment variables
export XDG_CONFIG_HOME="$HOME"/.config

echo "Creating directories"
# Create directories
mkdir -p "$XDG_CONFIG_HOME"/tmux
mkdir -p "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins



# installing dependencies
# tmux: don't forget to install plugins by running <prefix + I>
echo "Setting up repositories"

manage_repo "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
tmux source "$XDG_CONFIG_HOME"/tmux/tmux.conf

# neovim
manage_repo "https://github.com/jfgsilva/kickstart.nvim.git" "${XDG_CONFIG_HOME}"/nvim


# Symbolic links
echo "Creating symlinks"

ln -sf "$SCRIPT_DIR/tmux.conf" "$XDG_CONFIG_HOME"/tmux/tmux.conf
echo "Cleaning up nvim custom plugins"
rm "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/*

# ln -sf "$SCRIPT_DIR/nvim-plugins/filetree.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/filetree.lua
ln -sf "$SCRIPT_DIR/nvim-plugins/mini-icons.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/oil.lua
ln -sf "$SCRIPT_DIR/nvim-plugins/init.lua" "$XDG_CONFIG_HOME"/nvim/lua/custom/plugins/init.lua


