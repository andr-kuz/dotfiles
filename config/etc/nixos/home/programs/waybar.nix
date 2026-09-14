{ lib, pkgs, ... }: 
let
  trigger = builtins.pathExists /var/tmp/waybar.enable;
in
lib.mkIf trigger
{
  home.packages = with pkgs; [ 
    waybar
  ];
}
