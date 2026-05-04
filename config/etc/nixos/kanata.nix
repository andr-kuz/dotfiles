{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/kanata.enable;
in
lib.mkIf trigger {
  users.users.valtrois.extraGroups = [ "uinput" ];
  services.kanata = {
    enable = true;
    keyboards = {
      valtrois = {
        configFile = "${/home/valtrois/.dotfiles/kanata/kanata.kbd}";
      };
    };
  };
}
