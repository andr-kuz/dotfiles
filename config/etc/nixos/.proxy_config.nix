# rename this file to `proxy_config.nix` and put the bridge string in the variable
# The plugin client will be detected automatically
# Do not forget to `sudo nixos-rebuild switch` after
{
  bridges = [
    "obfs4 <IP>:<PORT> ..."
    "..."
  ];
  services.tor.settings = {
    StrictNodes = 0;
    # ExitNodes = "{ru}";
    ExcludeNodes = "{ru}";

    # --- Performance Enhancements ---
    CircuitBuildTimeout = 10;
    KeepAlivePeriod = 300;
    NewCircuitPeriod = 3600;
    MaxCircuitDirtiness = 3600;

    # --- Bandwidth Management ---
    RelayBandwidthRate = "100 MB";
    RelayBandwidthBurst = "150 MB";
    BandwidthRate = "100 MB";
    BandwidthBurst = "150 MB";
  };
}
