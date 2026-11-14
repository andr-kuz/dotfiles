{ lib, pkgs, ... }: 
let
  trigger = builtins.pathExists /var/tmp/laptop.enable;
in
lib.mkIf trigger
{
  home.packages = with pkgs; [ 
    brightnessctl
  ];
}
