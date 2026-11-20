{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdeconnect.enable;
in
lib.mkIf trigger {
  # programs.kdeconnect.enable = true; # commented out because it enables the global firewall
  environment.systemPackages = with pkgs; [ 
    wl-clipboard
    kdePackages.kdeconnect-kde
  ];

  networking.firewall = {
    extraCommands = ''
      iptables -A nixos-fw -p tcp -s 192.168.1.0/24 --dport 1714:1764 -j nixos-fw-accept
      iptables -A nixos-fw -p udp -s 192.168.1.0/24 --dport 1714:1764 -j nixos-fw-accept
    '';
  };
}
