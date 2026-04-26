{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/sox.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optional trigger sox;
}
