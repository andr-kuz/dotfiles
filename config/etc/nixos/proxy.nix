{ config, pkgs, lib, ... }:

let
  vars = import ./proxy_config.nix;
  bridges = vars.bridges;
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
    settings = {
      UseBridges = true;
      ClientTransportPlugin = plugin;
      Bridge = bridges;

      # ExitNodes = "{ru}";
      ExcludeNodes = "{de}";  # too many yt ads on `de`

      # 3. Allow Tor to use other nodes if necessary, but keep StrictNodes 0
      # This means Tor will PREFER to avoid German and US, but if it must, it will try.
      # If you set StrictNodes 1 and ExcludeNodes us, you might fail to connect
      # if no other paths exist. Keep it 0 for reliability.
      StrictNodes = 0;

      # --- Performance Enhancements ---
      CircuitBuildTimeout = 10;
      KeepAlivePeriod = 300;
      NewCircuitPeriod = 3600;
      MaxCircuitDirtiness = 3600;
      CookieAuthentication = true;  
      AvoidDiskWrites = 1; 
      HardwareAccel = 1;  
      SafeLogging = 1; 
      NumCPUs = 3;   

      # --- Bandwidth Management ---
      RelayBandwidthRate = "100 MB";
      RelayBandwidthBurst = "150 MB";
      BandwidthRate = "100 MB";
      BandwidthBurst = "150 MB";
    };
  };

  # services.privoxy = {
  #   enable = true;
  #   enableTor = true;
  # };

  # Operating a Snowflake proxy helps others circumvent censorship. Safe to run.
  services.snowflake-proxy = {
    enable = true;
    capacity = 10;
  };
}
