{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/tor_browser.enable;
in
lib.mkIf trigger {
  home.packages = [
    pkgs.tor-browser
  ];
}
