# to run it:
# $ nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/home/valtrois/.dotfiles/config/etc/nixos/vm.nix -o /home/valtrois/vm
# then
# $ ~/vm/bin/run-nixos-vm -display gtk,grab-on-hover=on

{ config, pkgs, ... }:

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
  ];

  # Create a demo user
  users.users.demo = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  services.xserver.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = "demo";
    };
  };

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # Required kernel modules for virtiofs
  boot.initrd.kernelModules = [ "virtiofs" ];
  boot.kernelModules = [ "virtiofs" ];
  virtualisation.sharedDirectories = {
    host-projects = {
      source = "/home/valtrois/videos";
      target = "/mnt/host-projects/videos";
    };
  };

  # Add useful packages
  environment.systemPackages = with pkgs; [ 
    curl 
    git 
    neovim 
    htop
    kitty
  ];

  system.stateVersion = "24.11";
}
