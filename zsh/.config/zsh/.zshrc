source "$ZDOTDIR/core.zsh"
source "$ZDOTDIR/aliases.zsh"
source "$ZDOTDIR/functions.zsh"
source "$ZDOTDIR/integrations.zsh"

# source local files
[[ -r "$ZSH_LOCAL_DIR/core.zsh" ]] &&
    source "$ZSH_LOCAL_DIR/core.zsh"

[[ -r "$ZSH_LOCAL_DIR/aliases.zsh" ]] &&
    source "$ZSH_LOCAL_DIR/aliases.zsh"

[[ -r "$ZSH_LOCAL_DIR/functions.zsh" ]] &&
    source "$ZSH_LOCAL_DIR/functions.zsh"

[[ -r "$ZSH_LOCAL_DIR/integrations.zsh" ]] &&
    source "$ZSH_LOCAL_DIR/integrations.zsh"

[[ -r "$ZSH_LOCAL_DIR/.zshrc" ]] &&
    source "$ZSH_LOCAL_DIR/.zshrc"
