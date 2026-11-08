{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/notifications.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs;
    [ 
      libnotify 
      mako 
    ];
}
