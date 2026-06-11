#!/usr/bin/env bash

cd ~/.dotfiles/config/REAPER/
mkdir -p ~/.config/REAPER
for n in ./*; do 
    if [ "$(basename "$n")" != "deploy.sh" ]; then
        ln -vrs "$n" ~/.config/REAPER/
    fi
done
