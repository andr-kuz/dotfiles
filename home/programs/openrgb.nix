{ lib, pkgs, ... }: 
let
  trigger = builtins.pathExists /var/tmp/openrgb.enable;
in
lib.mkIf trigger
{
  home.packages = with pkgs; [ 
    openrgb
  ];
}
