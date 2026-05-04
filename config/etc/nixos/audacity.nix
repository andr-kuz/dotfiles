{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/audacity.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs;
    [
      audacity
    ];
}
