let
  trigger = builtins.pathExists /var/tmp/sunshine.enable;
in
{
  # restart required after re-enabling
  services.sunshine = {
    enable = trigger;
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
