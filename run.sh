#!/usr/bin/env bash

# Check if the script is run as root (sudo)
if [ "$EUID" -ne 0 ]; then
    echo "Please run this script with sudo"
    exit 1
fi

if [ -n "$SUDO_USER" ]; then
    ORIGINAL_USER="$SUDO_USER"
    ORIGINAL_HOME=$(eval echo "~$SUDO_USER")
else
    echo "Error: Could not determine original user. Make sure to use 'sudo' not run as root directly."
    exit 1
fi

CONFIG_FILE="/etc/nixos/configuration.nix"
BACKUP_FILE="/etc/nixos/configuration.backup.nix"
NIXOS_CONFIG_PATH="$ORIGINAL_HOME/.dotfiles/config/etc/nixos"
SOURCE_FILE="$NIXOS_CONFIG_PATH/configuration.nix"

PROXY_CONFIG_TEMPLATE="$NIXOS_CONFIG_PATH/.proxy_config.nix"
PROXY_CONFIG_FILE="$NIXOS_CONFIG_PATH/proxy_config.nix"

if [ -e "$PROXY_CONFIG_TEMPLATE" ] && [ ! -f $PROXY_CONFIG_FILE ]; then
    cp $PROXY_CONFIG_TEMPLATE $PROXY_CONFIG_FILE
fi

# Check if the source file exists
if [ ! -f "$SOURCE_FILE" ]; then
    echo "Error: Source file $SOURCE_FILE does not exist"
    exit 1
fi

# Check if /etc/nixos/configuration.nix exists
if [ -e "$CONFIG_FILE" ]; then
    if [ -f "$CONFIG_FILE" ] && [ ! -L "$CONFIG_FILE" ]; then
        # It's a regular file (not a symlink)
        echo "Moving existing configuration file to backup..."
        mv "$CONFIG_FILE" "$BACKUP_FILE"
        echo "Creating symlink to new configuration..."
        ln -s "$SOURCE_FILE" "$CONFIG_FILE"
        echo "Done! Original file backed up as $BACKUP_FILE"
    elif [ -L "$CONFIG_FILE" ]; then
        # It's already a symlink
        echo "$CONFIG_FILE is already a symlink. Doing nothing."
    else
        # It exists but is neither a regular file nor a symlink
        echo "Error: $CONFIG_FILE exists but is neither a regular file nor a symlink"
        exit 1
    fi
else
    # File doesn't exist, just create the symlink
    echo "Creating symlink to configuration..."
    ln -s "$SOURCE_FILE" "$CONFIG_FILE"
    echo "Done!"
fi

nixos-rebuild switch

# Run nix command as the original user
echo "Running home-manager init as user $ORIGINAL_USER..."
sudo -u "$ORIGINAL_USER" nix run home-manager/release-25.11 -- init --switch --impure "$ORIGINAL_HOME/.dotfiles/"
