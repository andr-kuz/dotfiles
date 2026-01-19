{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    waydroid-nftables
  ];

  virtualisation.waydroid = {
    enable = true;
    package = pkgs.waydroid-nftables;
  };
  # https://wiki.nixos.org/wiki/Waydroid
  # `sudo waydroid init` to fetch waydroid images. You can add the parameters `-s GAPPS -f` to have GApps support.
  # use `sudo systemctl start waydroid-container` to start the container after installation
  # `waydroid session start` to start waydroid session
}
