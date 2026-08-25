# sudo yggdrasilctl getSelf
{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/yggdrasil.enable;
in
lib.mkIf trigger {
  services.yggdrasil = {
    enable = true;
    # Автоматически искать публичные узлы для выхода в сеть
    settings = {
      IfName = "ygg0";
      Peers = [
        "tcp://89.44.86.85:65535"
      ];
    };
  };
  # networking.firewall.interfaces."ygg0".allowedTCPPorts = [ 2352 ];
  # networking.firewall.interfaces."ygg0".allowedUDPPorts = [ 2352 ];
}
