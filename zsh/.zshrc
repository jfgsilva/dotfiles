export LC_CTYPE=en_US.UTF-8
# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="robbyrussell"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"


### DevOps CLI - ENVS
export DOCLI=/Users/jsilva/devops
export TF_VAR_DOCLI=/Users/jsilva/devops
export DOCLI_REPOSITORY=$HOME/Documents/GitHub/docli
export PATH=$DOCLI/bin:$PATH

### AWS - ENVS
export AWS_DEFAULT_OUTPUT=table
export AWS_PAGER=""
export PATH=$DOCLI/apps/aws/sessionmanager-bundle/bin:$PATH

### EXTRA LIBS, SOURCES AND SCRIPTS - ENVS

export TFENV_ARCH=amd64
export PATH=$HOME/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH
export PATH=/opt/homebrew/opt/curl/bin:$PATH
export PATH=/opt/homebrew/bin:$PATH
export PATH=/usr/local/opt/libpq/bin:$PATH
export PATH=$HOME/Library/Python/3.9/bin:$PATH
export PATH=/usr/local/opt/mysql-client/bin:$PATH
source $DOCLI/scripts/docli_colors_tput
source $HOME/.docli_envs
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

### ELASTICSEARCH - ENVS
export PATH=$DOCLI/apps/elasticsearch-8.12.1/bin:$PATH
export ES_HOME=$DOCLI/apps/elasticsearch-8.12.1

##

alias doco='export DOCLI_PROJECT_ROOT=~/Documents/BitBucket/ops-config && export DOCLI_PROJECT_CLIENT="co" && source $DOCLI/bin/setenv ent'
doco

## aliases to open directly in vscode
alias -s xml=code
alias -s py=code
alias -s json=code
alias -s txt=code
alias -s log=code
alias -s tf=code
alias -s yaml=code
alias -s yml=code
alias -s md=code


autoload -U +X bashcompinit && bashcompinit
complete -o nospace -C /opt/homebrew/Cellar/tfenv/3.0.0/versions/1.6.3/terraform terraform

bindkey "^B" backward-word
bindkey "^F" forward-word

# GO
export PATH="$HOME/go/bin:$PATH"

# nvim
alias vim="nvim"

# export local bin for custom made scripts
export PATH="$HOME/bin:$PATH"


# adding fzf integration
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh --tmux)

# estabilish easy ssh connections using oil and fzf

alias oil='~/bin/oil-ssh.sh'

vimgolf() {
    if [[ "$1" == "put" ]]; then
        local challenge_ID=$2
        docker run --rm -it -e "key=380a72755bc8c59d36e44b3790ff809b" ghcr.io/filbranden/vimgolf "$challenge_ID"
    else
        command vimgolf "$@"
    fi
}

# FC FIX COMMAND EDITOR
export FCEDIT=nvim

# COMMENT CLEANER

ccleaner() {
  # Check if the required file parameter is provided
  if [ -z "$1" ]; then
    echo "Usage: ccleaner <file> [-c]"
    return 1
  fi

  # Extract non-empty, non-comment lines
  local OUTPUT
  OUTPUT=$(grep -v "^\s*$" "$1" | grep -v "^\s*#")

  # Check if the second argument is "-c" to copy to clipboard
  if [[ "$2" == "-c" ]]; then
    echo "$OUTPUT" | pbcopy
  else
    echo "$OUTPUT"
  fi
}



export PATH="/opt/homebrew/opt/mysql-client/bin:$PATH"
export OLLAMA_HOST=0.0.0.0
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"


# Load secrets if they exist
[ -f "$HOME/.zsh_secrets" ] && source "$HOME/.zsh_secrets"
