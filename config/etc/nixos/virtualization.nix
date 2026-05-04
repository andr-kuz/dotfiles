{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/virtualization.enable;
in
lib.mkIf trigger {
  # KVM & IOMMU for AMD
  boot.kernelModules = [ "kvm-amd" ];

  # Enable KVM for your user
  users.users.valtrois.extraGroups = [ "kvm" "libvirtd" ];

  # Hugepages (optional but helps with RAM-intensive VMs)
  boot.kernel.sysctl = { "vm.nr_hugepages" = 2048; };

  boot.kernelParams = lib.mkMerge [
    # KVM & IOMMU for AMD
    [ "amd_iommu=on" "iommu=pt" ]
    # Hugepages
    (lib.mkAfter [ "hugepagesz=2M" "hugepages=2048" ])
  ];

  # Virtio GPU OpenGL on host requires virglrenderer
    environment.systemPackages = with pkgs; [ 
      virglrenderer qemu 
    ];
}
