{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/warp.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs; [
    amneziawg-tools
  ];

  boot.extraModulePackages = [ 
    pkgs.linuxPackages.amneziawg 
  ];
}
