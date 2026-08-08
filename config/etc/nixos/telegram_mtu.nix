{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/telegram.enable;
in
lib.mkIf trigger {
  networking.networkmanager.connectionConfig = {
    "ethernet.mtu" = 1200;
    "wifi.mtu" = 1200;
  };
}
