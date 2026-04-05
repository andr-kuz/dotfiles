{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/notifications.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optionals trigger [ libnotify mako ];
}
