{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/httptoolkit.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs; [
    httptoolkit
  ];

  programs.adb.enable = true;
  users.users.valtrois.extraGroups = [ "adbusers" ];
  # use `adb devices` to run adb daemon after waydroid container and session start
}
