# sudo mount -t vfat /dev/disk/by-label/DR-05X /mnt/tascam_dr_05x_recorder
{ config, pkgs, ... }:

{
  fileSystems."/mnt/tascam_dr_05x_recorder" = {
    device = "/dev/disk/by-label/DR-05X";
    fsType = "vfat";
    options = [ "defaults" "nofail" ];
  };
}
