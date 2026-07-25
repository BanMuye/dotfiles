# set history options
typeset -g HISTFILE="$XDG_CACHE_HOME/zsh/history"
typeset -g HISTSIZE=10000
typeset -g HISTSIZE=10000

mkdir -p '${HISTFILE:h}'

setopt APPEND_HISTORY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS

# reset cache path
autoload -Uz compinit
typeset -g ZSH_COMPDUMP="$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
mkdir -p "${ZSH_COMPDUMP:h}"
compinit -d "$ZSH_COMPDUMP"
