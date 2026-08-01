typeset -U path
typeset -U fpath

export JENV_ROOT="${JENV_ROOT:-$XDG_DATA_HOME/jenv}"

fpath=(
    /opt/homebrew/share/zsh/site-functions
    $fpath
    )

path=(
    "$HOME/.local/bin"

    /opt/homebrew/bin
    /opt/homebrew/sbin
    /usr/local/bin
    /usr/local/sbin

    $path
    )

export PATH
