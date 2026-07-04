{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/docker.enable;
in
lib.mkIf trigger {
  virtualisation.docker = {
    enable = true;
    rootless.enable = false;
  };
  users.users.valtrois.extraGroups = [ "docker" ];

  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "docker-28.5.2"
  ];
}
