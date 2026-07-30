{ lib, pkgs, ... }: 
let
  trigger = builtins.pathExists /var/tmp/openrgb.enable;
in
lib.mkIf trigger
{
  # 1. Force the kernel to activate the AMD SMBus controllers
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
  boot.kernelModules = [ "i2c-dev" "i2c-piix4" ];

  services.hardware.openrgb = { 
    enable = true; 
    package = pkgs.openrgb-with-all-plugins; 
    motherboard = "amd"; 
    server.port = 6742; 
  };

  # 2. Automatically shut down all LEDs on boot
  systemd.services.disable-rgb = {
    description = "Turn off all RGB lights";
    after = [ "openrgb.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --mode static --color 000000";
      RemainAfterExit = true;
    };
  };
}
