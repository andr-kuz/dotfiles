{ config, pkgs, lib, ... }:

let
  vars = import ./proxy_config.nix;
  bridges = vars.bridges;
  first_bridge = builtins.elemAt bridges 0;
  plugin = if (lib.hasPrefix "obfs4" first_bridge) then
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
      Bridge = bridges;
    };
  };

  services.privoxy =  {
   enable = true;
   enableTor = true;
  };
}
