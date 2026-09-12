{ lib, pkgs, config, ... }:

let
  trigger = builtins.pathExists /var/tmp/nvim.enable;
  neovim-nightly = "github:nix-community/neovim-nightly-overlay";
  chosenNeovim = if trigger then neovim-nightly else pkgs.neovim;
in
{
  home.packages = [
    chosenNeovim
    
    # neovim plugins requirements
    pkgs.tree-sitter
    pkgs.nodejs
    pkgs.yarn
    pkgs.gcc
    pkgs.clang-tools
    pkgs.pyright
    pkgs.rustup
    pkgs.unzip
    pkgs.libxkbfile
    pkgs.python3
    pkgs.fzf
    pkgs.ripgrep
  ];

  xdg.configFile."nvim" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";
  };
}
