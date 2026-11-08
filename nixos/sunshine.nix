{ lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/sunshine.enable;
in
lib.mkIf trigger {
  # restart required after re-enabling
  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
      userServices = true;
    };
  };
}
