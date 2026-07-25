#!/usr/bin/env bash

set -euo pipefail

DOTFILES_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
STOW_PACKAGES=(
    git
    nvim
    zsh
    ghostty
)

check_homebrew() {
    if ! command -v brew >/dev/null 2>&1; then
        echo "Error: Homebrew is required" >&2
        exit 1
    fi
}

check_stow() {
    if ! command -v stow >/dev/null 2>&1; then
        echo "Error: GNU Stow is required." >&2
        exit 1
    fi
}

homebrew_install() {
    check_homebrew
    brew bundle --file="$DOTFILES_DIR/Brewfile"
}

homebrew_dry_run() {
    echo "Checking Homebrew packages..."
    check_homebrew

    local brewfile="$DOTFILES_DIR/Brewfile"
    local formulae
    local casks

    formulae="$(brew bundle list --formula --file="$brewfile")"
    casks="$(brew bundle list --cask --file="$brewfile")"

    if [[ -n "$formulae" ]]; then
        echo
        echo "Homebrew formulae:"
        brew info --formula $formulae |
            sed -n '/^==> .*/p; /^From:/p'
    fi

    if [[ -n "$casks" ]]; then
        echo
        echo "Homebrew casks:"
        brew info --casks $casks |
            sed -n '/^==> .*:/p; /^From:/p'
    fi

    echo
    echo "Homebrew package sources resolved successfully."
    echo
    echo "Homebrew installation status:"

    if brew bundle check --verbose --file="$brewfile"; then
        echo "All Homebrew dependencies are satisfied"
    else
        echo "The dependencies listed above would be installed or upgraded."
    fi
}

run_stow() {
    check_stow

    (
        cd "$DOTFILES_DIR"
        stow "$@" "${STOW_PACKAGES[@]}"
    )
}

simulate_stow() {
    echo
    echo "Simulating Stow..."
    run_stow --simulate --verbose=2 --restow
}

link_dotfiles() {
    echo
    echo "Linking dotfiles..."
    run_stow --restow
}

dry_run() {
    homebrew_dry_run
    simulate_stow
    echo
    echo "Dry-run completed successfully"
}

install() {
    homebrew_install
    link_dotfiles
    echo
    echo "Dotfiles installed successfully"
}

usage() {
    echo "Usage:"
    echo "  $0             Install dependencies and link dotfiles"
    echo "  $0 --dry-run   Check dependencies and simulate Stow"
    echo "  $0 --help      Show this help"
}

main() {
    case "${1:-}" in
        "")
            install
            ;;
        --dry-run)
            dry_run
            ;;
        --help | -h)
            usage
            ;;
        *)
            echo "Unknown option: $1" >&2
            echo >&2
            usage >&2
            exit 1
            ;;
    esac
}

main "$@"
