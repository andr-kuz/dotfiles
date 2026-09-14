{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/telegram.enable;
in

lib.mkIf trigger {
  home.packages = with pkgs; [
    telegram-desktop
  ];
}
