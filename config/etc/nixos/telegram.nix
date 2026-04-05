{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/telegram.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optional trigger telegram-desktop;
}
