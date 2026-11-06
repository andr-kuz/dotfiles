{ pkgs, inputs, ... }:
let
  triggerEdge = builtins.pathExists /var/tmp/kitty_edge.enable;
  # we need yazi-overlay for Drag'n'Drop feature support
  chosenKitty = if triggerEdge then inputs.yazi-overlay.packages.${pkgs.stdenv.hostPlatform.system}.default else pkgs.yazi;
in
{
  programs.yazi = {
    enable = true;
    package = chosenKitty.override {
      _7zz = pkgs._7zz-rar; # Support for RAR extraction
    };
    plugins = {
      split-tabs = pkgs.yaziPlugins.split-tabs;
    };
  };
}
