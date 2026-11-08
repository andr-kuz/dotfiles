{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/tor_browser.enable;
in
lib.mkIf trigger {
  # 1. Установка самого Tor Browser
  home.packages = [
    pkgs.tor-browser
  ];
}
