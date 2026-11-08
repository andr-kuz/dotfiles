{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/tor_routing.enable;
in
lib.mkIf trigger {
  services.tor.settings = {
    TransPort = 9040;
  };
  networking.nftables = {
    enable = true;
    # 1000 is default `uid`
    # you can check it by executing `id -u` or `id -u <USERNAME>` then change it here
    # to check if traffic is routing evaluate `sudo nix-shell -p nftables --run "nft list ruleset"` and look up for `table inet nat` rule
    ruleset = ''
      table inet nat {
        chain output {
          type nat hook output priority -100; policy accept;
          meta skuid 1000 meta l4proto tcp redirect to :9040
        }
      }
    '';
  };
}
