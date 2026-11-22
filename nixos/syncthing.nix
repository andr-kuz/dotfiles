{...}:

{
  services.syncthing = {
    # https://wiki.nixos.org/wiki/Syncthing
    enable = true;
    openDefaultPorts = false;  # we open them below
    user = "valtrois";
    group = "users";
    dataDir = "/home/valtrois/shared";
    configDir = "/home/valtrois/.local/state/syncthing";
    settings = {
      devices = {
        "laptop" = { id = "QHZ5L5D-X5EOWES-VRD4GAF-ZUBVGKN-HE3RTSY-APYIGS5-WLGQH6R-JFRROQB"; };
        "phone" = { id = "WWJ7M3F-NJGCQNO-CG25N33-IJGYJJG-KTWI56C-QKQ4MUZ-5JH2YMD-LTAYMQZ"; };
        "pc" = { id = "NAAEPD2-BE3NUXS-FMLTRIF-WSCNF4V-EWJLK6L-2FWNLRD-SVCLN3U-JZ5USAU"; };
      };
      folders = {
        "Sync" = {
          path = "/home/valtrois/Sync/";
          devices = [ "laptop" "phone" "pc" ];
        };
        "Pictures" = {
          path = "/home/valtrois/Pictures/";
          devices = [ "laptop" "phone" "pc" ];
        };
        "jf0or-2y7eu" = {  # phone folder unique ID declared by Syncthing-Fork Android app
          label = "DCIM";
          path = "/home/valtrois/DCIM";
          devices = [ "laptop" "phone" "pc"];
          ignorePerms = false; # Matches ignorePerms="false" from the original XML configuration
        };
      };
    };
  };

  networking.firewall.extraCommands = ''
    # Allow Syncthing sync traffic only from your local subnet
    iptables -A nixos-fw -p tcp --dport 22000 -s 192.168.1.0/24 -j nixos-fw-accept
    iptables -A nixos-fw -p udp --dport 22000 -s 192.168.1.0/24 -j nixos-fw-accept
    
    # Allow local discovery broadcasts on your local subnet
    iptables -A nixos-fw -p udp --dport 21027 -s 192.168.1.0/24 -j nixos-fw-accept
  '';
}
