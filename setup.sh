#!/bin/bash

cd "$(dirname "$0")" || exit 1

LN_OPTS="-sT"

if [[ "$1" = "-f" ]] || [[ "$1" = "--force" ]]; then
    echo "(Force-installing)"
    LN_OPTS+="f"
    shift
else
    LN_OPTS+="i"
fi

DOTFILES_DIR="${1:-$HOME}"

echo "Current path: $PWD"
echo "Installing to: $DOTFILES_DIR"
echo "--- Linking directories & files ---"

safe-link() {
    echo "> Linking '$1'"
    SOURCE="$PWD/$1"
    DEST="$DOTFILES_DIR/$1"

    if [[ -d "$SOURCE" ]] && [[ -d "$DEST" ]] && [[ ! -L "$DEST" ]]; then
        echo "! Made a backup of pre-existing '$1'"
        mv "$DEST" "$DEST.bak.$(date '+%D-%T' | tr ':/' '-')"
    fi

    ln "$LN_OPTS" "$SOURCE" "$DEST"
}

safe-link .bin
safe-link .zshrc
safe-link .zpreztorc
safe-link .gitignore
safe-link .tmux.conf
if [[ "$(uname)" == Linux ]]; then
    safe-link .xinitrc
    safe-link .Xresources

    XTHEMES_DIR="$DOTFILES_DIR/.config/rice/Xthemes"

    if [[ -d "$XTHEMES_DIR" ]] && [[ ! -L "$XTHEMES_DIR/_selected" ]]; then
        echo "Setting google.xresources as the default rice theme"
        ln -s "$XTHEMES_DIR/google.xresources" "$XTHEMES_DIR/_selected"
    fi
fi

mkdir -p "$DOTFILES_DIR/.config"
for file in "$PWD/.config/"*; do
    safe-link ".config/$(basename "$file")"
done

mkdir -p "$HOME/.templates"
for file in "$PWD/.templates/"*; do
    safe-link ".templates/$(basename "$file")"
done

