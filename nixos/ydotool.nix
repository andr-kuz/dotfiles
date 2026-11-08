{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/ydotool.enable;
in
lib.mkIf trigger {
  users.users.valtrois.extraGroups = [ "ydotool" ];
  # reboot required
  programs.ydotool.enable = true;
}
