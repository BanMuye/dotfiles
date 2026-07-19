homebrew_install() {
    if ! command -v brew > /dev/null 2>&1; then
        echo "Homebrew is required" >& 2
        exit 1
    fi

    brew bundle \
        --file = "$DOTFILES_DIR/Brewfile"
    }
