{ lib, pkgs, ... }: 
let
  trigger = builtins.pathExists /var/tmp/rnote.enable;
in
lib.mkIf trigger
{
  home.packages = with pkgs; [
    rnote
  ];
}
