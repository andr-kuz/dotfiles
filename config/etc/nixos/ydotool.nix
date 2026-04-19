{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/ydotool.enable;
in
{
  users.users.valtrois.extraGroups = lib.mkIf trigger [ "ydotool" ];
  # reboot required
  programs.ydotool.enable = trigger;
}
