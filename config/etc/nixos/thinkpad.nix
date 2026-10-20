{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/thinkpad.enable;
in
lib.mkIf trigger {
  # should fix `Realtek RTL8852AE` network adapter driver interaction with the kernel
  # and prevent its crash on power on
  boot.kernelParams = [ "rtw89_core.disable_aspm=y" ];
}
