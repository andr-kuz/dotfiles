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
    controlSocket.enable = true; # Enables ControlSocket & CookieAuthentication for shared Tor connection automatically
    settings = {
      UseBridges = true;
      ClientTransportPlugin = plugin;
      Bridge = bridges;
      # Optional: Add a dedicated SOCKSPort for Tor Browser to keep stream isolation separate from Privoxy
      SOCKSPort = [ 9150 ];
    };
  };

  services.privoxy = {
    enable = true;
    enableTor = true;
  };

  users.users.valtrois.extraGroups = [ "tor" ];

  environment.sessionVariables = {
    TOR_SKIP_LAUNCH = "1";
    TOR_SOCKS_PORT = "9150";
    TOR_CONTROL_SOCKET = "/run/tor/control";
  };
}
