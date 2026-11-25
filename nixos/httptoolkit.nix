{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/httptoolkit.enable;
in
lib.mkIf trigger {
  # use `adb devices` to run adb daemon after waydroid container and session start
  programs.adb.enable = true;
  users.users.valtrois.extraGroups = [ "adbusers" ];
  environment.systemPackages = with pkgs; [
    httptoolkit
    frida-tools
  ];
  networking.firewall.trustedInterfaces = [ "waydroid0" ];
}
