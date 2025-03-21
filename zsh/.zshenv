ZSH_SECRETS="$HOME/.zsh_secrets"
ZSH_SECRETS_GPG="$HOME/.dotfiles/zsh/.zsh_secrets.gpg"

if [ ! -f "$ZSH_SECRETS" ] && [ -f "$ZSH_SECRETS_GPG" ]; then
    gpg --quiet --decrypt "$ZSH_SECRETS_GPG" > "$ZSH_SECRETS"
    chmod 600 "$ZSH_SECRETS"
fi
