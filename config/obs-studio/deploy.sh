#!/usr/bin/env bash

cd ~/.dotfiles/config/obs-studio/
mkdir -p ~/.config/obs-studio
find . -type f | while read -r n; do
    if [ "$(basename "$n")" != "deploy.sh" ]; then
        target_dir="$HOME/.config/obs-studio/$(dirname "$n")"
        mkdir -p "$target_dir"
        ln -vrs "$n" "$target_dir/"
    fi
done
