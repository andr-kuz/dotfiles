{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/audacity.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optional trigger audacity;
}
