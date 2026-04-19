{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/virtualization.enable;
in
{
  # KVM & IOMMU for AMD
  boot.kernelModules = lib.mkIf trigger [ "kvm-amd" ];

  # Enable KVM for your user
  users.users.valtrois.extraGroups = lib.mkIf trigger [ "kvm" "libvirtd" ];

  # Hugepages (optional but helps with RAM-intensive VMs)
  boot.kernel.sysctl = lib.mkIf trigger { "vm.nr_hugepages" = 2048; };

  boot.kernelParams = lib.mkMerge [
    # KVM & IOMMU for AMD
    (lib.mkIf trigger [ "amd_iommu=on" "iommu=pt" ])
    # Hugepages
    (lib.mkIf trigger (lib.mkAfter [ "hugepagesz=2M" "hugepages=2048" ]))
  ];

  # Virtio GPU OpenGL on host requires virglrenderer
  environment.systemPackages = lib.mkIf trigger (with pkgs; [ 
    virglrenderer qemu 
  ]);
}
