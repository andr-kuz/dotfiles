{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/duckdns.enable;
  vars = import ./duckdns_config.nix;
in
lib.mkIf trigger {
  systemd.services.duckdns-updater = {
    description = "Duck DNS Dynamic IP Updater";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    
    script = ''
      ${pkgs.curl}/bin/curl -k "https://www.duckdns.org/update?domains=${vars.duckDnsDomain}&token=${vars.duckDnsToken}&ipv6=$(${pkgs.iproute2}/bin/ip -6 addr show dev ygg0 | grep -oP '(?<=inet6 )[0-9a-f:]+' | head -n 1)"
    '';

    serviceConfig = {
      Type = "oneshot";
      # Security hardening: run as a dynamic user instead of root
      DynamicUser = true;
    };
  };

  # 3. Create a timer to trigger the service every 5 minutes
  systemd.timers.duckdns-updater = {
    description = "Trigger Duck DNS update periodically";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1m";
      OnUnitActiveSec = "5m";
    };
  };
}
