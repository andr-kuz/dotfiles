{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/httptoolkit.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs; [
    httptoolkit
  ];
}
