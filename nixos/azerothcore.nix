{ ... }:
{
  networking.firewall = {
    # wow Azerothcore ports
    # TCP 3724 for auth server
    # TCP 8085 for world server
    # check rules with `sudo iptables -L nixos-fw -n -v`
    extraCommands = ''
      iptables -A nixos-fw -p tcp -s 192.168.1.0/24 --dport 3724 -j nixos-fw-accept
      iptables -A nixos-fw -p tcp -s 192.168.1.0/24 --dport 8085 -j nixos-fw-accept
    '';
  };
}
