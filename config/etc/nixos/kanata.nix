{
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
