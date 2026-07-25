# Prompt
if (( $+commands[startship] )); then
    eval "$(startship init zsh)"
fi

# directory navigation
if (( $+commands[zoxide] )); then
    eval "$(zoxide init zsh --cmd cd)"
fi
