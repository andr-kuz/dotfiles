{ lib, pkgs, inputs, config, ... }:

let
  trigger = builtins.pathExists /var/tmp/nvim.enable;
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
in
{
  config = lib.mkIf trigger {
    home.packages = [
      neovim-nightly
      # neovim plugins requirements
      nodejs
      yarn
      gcc
      clang-tools
      pyright
      rustup
      unzip
      libxkbfile
      python3
      fzf
      ripgrep
    ];

    xdg.configFile."nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";
    };
  };
}

