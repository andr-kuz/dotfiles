{ lib, pkgs, inputs, config, ... }:

let
  trigger = builtins.pathExists /var/tmp/nvim.enable;
  neovim-nightly = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
  chosenNeovim = if trigger then neovim-nightly else pkgs.neovim;
in
{
  home.packages = [
    chosenNeovim
    
    # neovim plugins requirements
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
