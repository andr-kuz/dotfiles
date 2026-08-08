{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/wifi.disable;
in
lib.mkIf trigger {
  systemd.services.disable-wifi = {
    description = "Globally block all Wi-Fi radios via rfkill";
    wantedBy = [ "multi-user.target" ];
    before = [ "network.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill block wifi";
      RemainAfterExit = true;
    };
  };
}
