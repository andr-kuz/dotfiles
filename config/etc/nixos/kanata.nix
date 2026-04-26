{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/kanata.enable;
in
{
  users.users.valtrois.extraGroups = lib.mkIf trigger [ "uinput" ];
  services.kanata = {
    enable = trigger;
    keyboards = {
      valtrois = {
        configFile = "${/home/valtrois/.dotfiles/kanata/kanata.kbd}";
      };
    };
  };
}
