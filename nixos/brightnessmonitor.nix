# `ddcutil getvcp 10`       get brightness value
# `ddcutil setvcp 10 - 10`  decrease brightness by 10%
# `ddcutil setvcp 10 + 10`  increase brightness by 10%
# `ddcutil setvcp 10 50`    set brightness to 50%
{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/brightnessmonitor.enable;
in
{
  boot.kernelModules = [ "i2c-dev" ];
  hardware.i2c.enable = true;
  users.users.valtrois.extraGroups = [ "i2c" ];
  environment.systemPackages = [
    pkgs.ddcutil
  ];
}
