typeset -U path

path=(
    "$HOME/.local/bin"

    /opt/homebrew/bin
    /opt/homebrew/sbin
    /usr/local/bin
    /usr/local/sbin

    $path
    )

export PATH
