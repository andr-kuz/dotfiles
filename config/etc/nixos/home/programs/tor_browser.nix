{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdenlive.enable;
in
lib.mkIf trigger {
  # 1. Установка самого Tor Browser
  home.packages = [
    pkgs.tor-browser
  ];

  # 2. Переменные окружения для принудительного использования системного Tor
  home.sessionVariables = {
    TOR_SKIP_LAUNCH = "1";
    TOR_SOCKS_PORT = "9050";
    TOR_CONTROL_PORT = "9051";
    # Путь к куки авторизации в NixOS
    TOR_CONTROL_COOKIE_AUTH_FILE = "/var/lib/tor/control_auth_cookie";
  };
}
