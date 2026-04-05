{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdeconnect.enable;
in
{
  programs.kdeconnect.enable = trigger;
  environment.systemPackages = with pkgs; [
    xdg-desktop-portal-hyprland
  ];

  # networking.firewall = lib.mkIf trigger (rec {
  #   allowedTCPPortRanges = [ { from = 1714; to = 1764; } ];
  #   allowedUDPPortRanges = allowedTCPPortRanges;
  # });
}
