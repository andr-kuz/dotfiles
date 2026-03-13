{ config, pkgs, ... }:

{
  fileSystems."/mnt/16_microsd_music" = {
    device = "/dev/disk/by-uuid/1802-1612";
    fsType = "vfat";
    options = [ "defaults" "nofail" ];
  };
}
