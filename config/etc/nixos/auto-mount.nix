{ config, pkgs, ... }:

{
  fileSystems."/mnt/external" = {
    # my external SSD
    device = "/dev/disk/by-uuid/d42532f8-b3ba-4f3b-ab3b-be47dc732a07";
    fsType = "ext4";
    options = [ "defaults" "nofail" ];
  };
}
