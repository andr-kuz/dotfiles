{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/android_adb.enable;
in
lib.mkIf trigger {
  programs.adb.enable = true;
  users.users.valtrois.extraGroups = [ "adbusers" ];
  # use `adb devices` to run adb daemon after waydroid container and session start
}
