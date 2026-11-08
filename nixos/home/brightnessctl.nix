{ lib, pkgs, ... }: 
let
  trigger = builtins.pathExists /var/tmp/brightnessctl.enable;
in
lib.mkIf trigger
{
  home.packages = with pkgs; [ 
    brightnessctl
  ];
}
