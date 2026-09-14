{ pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    # You can omit this if you use overlays
    package = pkgs.yazi.override {
      _7zz = pkgs._7zz-rar;  # Support for RAR extraction
    };
    plugins = {
      split-tabs = pkgs.yaziPlugins.split-tabs;
    };
  };
}
