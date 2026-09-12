{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/wine.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs; [
    wineWow64Packages.stable
    winetricks
  ];
}
