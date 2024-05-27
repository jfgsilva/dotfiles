# This file should be executed just after cloning this repository

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

# Create directories
mkdir -p "$XDG_CONFIG_HOME"/tmux


# Symbolic links
ln -sf "$SCRIPT_DIR/tmux.conf" "$XDG_CONFIG_HOME"/tmux/tmux.conf

# installing dependencies
# tmux: don't forget to install plugins by running <prefix + I>
manage_repo "https://github.com/tmux-plugins/tpm" "$HOME/.tmux/plugins/tpm"
tmux source "$XDG_CONFIG_HOME"/tmux/tmux.conf

