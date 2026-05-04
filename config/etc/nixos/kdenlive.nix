{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdenlive.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs;
    [
      kdePackages.kdenlive
    ];
}
