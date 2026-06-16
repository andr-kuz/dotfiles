{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/telegram.enable;
in

lib.mkIf trigger {
    environment.systemPackages = with pkgs; [
      telegram-desktop
    ];
}
