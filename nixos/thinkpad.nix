{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/thinkpad.enable;
in
lib.mkIf trigger {
  systemd.services.NetworkManager = {
    wantedBy = [ "network.target" ];
  };
}
