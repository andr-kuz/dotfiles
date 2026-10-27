{ pkgs, lib, ... }:

let
  env = builtins.fromTOML (builtins.readFile ./env.toml);
  bridges = lib.splitString "," env.TOR_TUNNELS;
  first_bridge = builtins.elemAt bridges 0;
  plugin = if (lib.hasPrefix "obfs4" first_bridge) then
    "obfs4 exec ${pkgs.obfs4}/bin/lyrebird"
  else if (lib.hasPrefix "webtunnel" first_bridge) then
    "webtunnel exec ${pkgs.webtunnel}/bin/client"
  else
    "snowflake exec ${pkgs.snowflake}/bin/client";
in 
{
  services.tor = {
    enable = true;
    client.enable = true;
    settings = {
      UseBridges = true;
      ClientTransportPlugin = plugin;
      Bridge = bridges;
      # Открываем SOCKS-порт с изоляцией
      SocksPort = "127.0.0.1:9050 IPv6Traffic PreferIPv6 KeepAliveIsolateSOCKSAuth";
      # Обязательно для работы Tor Browser
      ControlPort = "127.0.0.1:9051"; 
      CookieAuthentication = true;
      CookieAuthFileGroupReadable = true;
    };
  };

  services.privoxy = {
    enable = true;
    enableTor = true;
  };

  users.users.valtrois.extraGroups = [ "tor" ];
}
