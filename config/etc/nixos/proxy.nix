{ config, pkgs, lib, ... }:

let
  vars = import ./.proxy_config.nix;
  bridge = vars.bridge;
  plugin = if (lib.hasPrefix "obfs4" bridge) then
    "obfs4 exec ${pkgs.obfs4}/bin/lyrebird"
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
      Bridge = bridge;
    };
  };

  services.privoxy =  {
   enable = true;
   enableTor = true;
  };
}
