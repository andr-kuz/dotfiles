{ config, pkgs, ... }:

{
  services.postgresql = {
    enable = true;
    # Optional: Specify a specific version if needed (e.g., pgsql_16 is default in current NixOS)
    # package = pkgs.postgresql_16; 
    # Optional: Configure authentication methods
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
    # Optional: Enable TCP/IP connections (default is Unix socket only)
    # enableTCPIP = true; 
  };
}
