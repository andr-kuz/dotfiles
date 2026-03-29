{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /tmp/notifications.enable;
in
{
  environment.systemPackages = with pkgs;
    lib.optionals trigger [ libnotify mako ];
}
