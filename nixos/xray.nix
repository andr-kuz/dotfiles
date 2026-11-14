{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/xray.enable;
in
lib.mkIf trigger {
  services.xray = {
    enable = true;
    settingsFile = "/home/valtrois/xray.json"; # путь к твоему клиентскому конфигу
  };
}
