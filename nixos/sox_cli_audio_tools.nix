{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/sox.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs;
    [
      sox
    ];
}
