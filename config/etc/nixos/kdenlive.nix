{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdenlive.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optional trigger kdePackages.kdenlive;
}
