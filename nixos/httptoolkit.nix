{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/httptoolkit.enable;
in
lib.mkIf trigger {
  # use `adb devices` to run adb daemon after waydroid container and session start
  users.users.valtrois.extraGroups = [ "adbusers" ];
  environment.systemPackages = with pkgs; [
    httptoolkit
    android-tools
    frida-tools
  ];
  networking.firewall.trustedInterfaces = [ "waydroid0" ];
}
