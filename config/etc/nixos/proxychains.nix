{ pkgs, lib,... }:

let
  trigger = builtins.pathExists /var/tmp/proxychains.enable;
in
lib.mkIf trigger {
  programs.proxychains = {
    enable = true;
    package = pkgs.proxychains-ng; # Uses proxychains-ng by default
    chain.type = "strict";       # Options: strict, dynamic, random
    proxies = {
      myproxy = {
        enable = true;
        type = "socks5";
        host = "127.0.0.1";
        port = 9050;
      };
    };
  };
}
