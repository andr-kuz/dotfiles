# sudo mount -t exfat /dev/disk/by-uuid/BAA5-3096 /mnt/BAA5-3096
{ ... }:

{
  fileSystems."/mnt/16_microsd_music" = {
    device = "/dev/disk/by-uuid/1802-1612";
    fsType = "vfat";
    options = [ "defaults" "nofail" ];
  };
}
