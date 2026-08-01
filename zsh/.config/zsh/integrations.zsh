# Java version manager
if (( $+commands[jenv] )); then
    eval "$(jenv init -)"
fi

# Prompt
if (( $+commands[starship] )); then
    eval "$(starship init zsh)"
fi

# directory navigation
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh --cmd cd)"
fi
