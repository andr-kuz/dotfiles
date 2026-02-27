{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /tmp/telegram.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optional trigger telegram-desktop;
}
