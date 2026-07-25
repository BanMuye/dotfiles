# set XDG variables
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.confg}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

# don't export, let new session start from ~/.zshenv
ZDOTDIR="$XDG_CONFIG_HOME/zsh"

# set local zsh path
ZSH_LOCAL_DIR="$HOME/.config/zsh-local"
