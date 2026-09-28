{ lib, pkgs, config, inputs, ... }:

let
  triggerRegular = builtins.pathExists /var/tmp/nvim.enable;
  triggerNightly = builtins.pathExists /var/tmp/nvim_nightly.enable;
  chosenNeovim = if triggerNightly 
    then inputs.neovim-nightly-overlay.packages.${pkgs.system}.default 
    else pkgs.neovim;
  trigger = triggerNightly || triggerRegular;
in
lib.mkIf trigger
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
