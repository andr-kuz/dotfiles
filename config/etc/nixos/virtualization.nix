{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/virtualization.enable;
in
lib.mkIf trigger {
  # KVM & IOMMU for AMD
  boot.kernelModules = [
    "kvm-amd"
  ];

  # Enable KVM for your user
  users.users.valtrois.extraGroups = [
    "kvm"
    "libvirtd"
  ];

  # Hugepages (optional but helps with RAM-intensive VMs)
  # boot.kernel.sysctl = { "vm.nr_hugepages" = 2048; };

  boot.kernelParams = [ 
    "amd_iommu=on" 
    "iommu=pt" 
    # "hugepagesz=2M" 
    # "hugepages=2048" # disabling hugepages for better windows-wsl communication
    "kvm.ignore_msrs=1" # (Рекомендуется для стабильности Windows)
    "kvm_amd.nested=1" # Nested virtualization for WSL and Docker inside Windows
  ];

  # Virtio GPU OpenGL on host requires virglrenderer
  environment.systemPackages = with pkgs; [
    virglrenderer
    qemu
    virt-manager  # GUI to create and run VMs
  ];

  # Включение службы libvirtd и поддержка UEFI (OVMF включен по умолчанию)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true; # Эмуляция TPM (полезно для Windows 10/11)
    };
    # 1. Разрешаем libvirt управлять стандартным сетевым мостом virbr0
    allowedBridges = [ "virbr0" ];
  };

  # 2. Разрешаем пересылку трафика на уровне ядра Linux (необходимо для работы NAT в сети default)
  # boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
  #
  # # Декларативный автозапуск сети default при старте системы
  # systemd.services.libvirt-default-network = {
  #   description = "Автоматический запуск виртуальной сети Libvirt (default)";
  #   after = [ "libvirtd.service" ]; # Ждем, пока запустится сам libvirt
  #   wantedBy = [ "multi-user.target" ];
  #   serviceConfig = {
  #     Type = "oneshot";
  #     RemainAfterExit = true;
  #     ExecStart = "${pkgs.libvirt}/bin/virsh net-start default";
  #     ExecStop = "${pkgs.libvirt}/bin/virsh net-destroy default";
  #   };
  # };
}
