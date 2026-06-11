#!/usr/bin/env bash

mkdir -p ~/.config/REAPER
for n in ./*; do ln -vs "$n" ~/.config/REAPER; done
