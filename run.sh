#!/usr/bin/env bash

# 1. Parse arguments first (before root checks, so -h/--help works safely)
UPDATE_MODE=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    -u|--update)
      UPDATE_MODE=true
      shift
      ;;
    -h|--help)
      echo "Usage: sudo $0 [-u|--update]"
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      echo "Usage: sudo $0 [-u|--update]"
      exit 1
      ;;
  esac
done

# Check if the script is run as root (sudo)
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit 1
fi

SYSTEM_PATH="/etc/nixos"
SCRIPT_DIR=$(cd -- "$(dirname -- "$0")" && pwd)

file_list=("config/etc/nixos/home/home.nix" "flake.nix" "config/etc/nixos/configuration.nix")
for item in "${file_list[@]}"
do
  FILE=$(basename $item)
  ORIGINAL_FILE="$SCRIPT_DIR/$item"
  FILE_PATH="$SYSTEM_PATH/$FILE"

  # 1. check if original file exists
  if [ ! -f "$ORIGINAL_FILE" ]; then
    echo "Error: file $ORIGINAL_FILE does not exist"
    continue
  fi

  # 2. check if backup needed
  if [ -f "$FILE_PATH" ] && [ ! -L "$FILE_PATH" ]; then
    echo "Moving existing $ORIGINAL_FILE file to backup..."
    mv "$FILE_PATH" "$FILE_PATH.backup"
    rm "$FILE_PATH"
  elif [ -L "$FILE_PATH" ]; then
    echo "$FILE_PATH is already a symlink. Doing nothing."
    continue
  elif [ ! -f "$FILE_PATH" ]; then
    echo "$FILE_PATH not exists"
  else
    # It exists but is neither a regular file nor a symlink
    echo "Error: $FILE_PATH exists but is neither a regular file nor a symlink"
    continue
  fi

  echo "Creating a symlink to $ORIGINAL_FILE"
  ln -s "$ORIGINAL_FILE" "$FILE_PATH"
done

# 2. Conditional Channel Update
if [ "$UPDATE_MODE" = true ]; then
    echo "🔄 Updating Nix channels..."
    nix flake update
fi

# excluding env.toml so we're not indexing any changes in there
git add --intent-to-add ./config/etc/nixos/env.toml
# use --impure if you need to allow absolute path import like `/etc/nixos/hardware-configuration.nix`
nixos-rebuild switch --flake . --impure  # add `--option binary-caches "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"` if nixos cache is not responding
