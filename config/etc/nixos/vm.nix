# to run it:
# $ nix-build '<nixpkgs/nixos>' -A vm -I nixos-config=/home/valtrois/.dotfiles/config/etc/nixos/vm.nix -o /home/valtrois/vm
# then
# $ ~/vm/bin/run-nixos-vm -display gtk,grab-on-hover=on

{ config, pkgs, ... }:

let
  username = "demo";
in

{
  imports = [
    <nixpkgs/nixos/modules/virtualisation/qemu-vm.nix>
    <home-manager/nixos>
      ./obs_studio.nix
  ];

  # ========== PERFORMANCE OPTIMIZATIONS ==========
  
  # 1. CPU & KVM Acceleration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  virtualisation.qemu.options = [
    "-display" "gtk,grab-on-hover=on"

    "-cpu" "host"           # Pass through host CPU features
    "-enable-kvm"           # Enable KVM acceleration (critical!)
    "-smp" "4"              # Allocate multiple CPU cores (adjust to your host)
    # Graphics
    "-vga" "virtio"

    # SPICE device
    "-device" "virtio-serial-pci"
    "-device" "virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
    "-chardev" "spicevmc,id=spicechannel0,name=vdagent"
  ];

  # 2. Memory - Hugepages support
  boot.kernelParams = [
    "hugepagesz=1G" 
    "hugepages=24"          # 24GB of 1GB hugepages (adjust to your RAM)
  ];

  # Required kernel modules for virtio and KVM
  boot.initrd.kernelModules = [ "virtiofs" "virtio_scsi" ];

  # 3. Power Management - Performance governor
  powerManagement.cpuFreqGovernor = "performance";

  # 4. QEMU Guest Agent for better integration
  services.qemuGuest.enable = true;

  # 5. SPICE for better graphics performance
  services.spice-vdagentd.enable = true;

  # 6. Optimize disk I/O - Use virtio-blk with writeback cache
  virtualisation.diskSize = 20480;  # 20GB disk
  virtualisation.qemu.diskInterface = "virtio";

  # 7. Optimize network with virtio
  virtualisation.qemu.networkingOptions = [
    "-netdev" "user,id=net0"
    "-device" "virtio-net-pci,netdev=net0"
  ];

  # ========== THE REST ==========
  boot.kernelModules = [ "virtiofs" "kvm-amd" "vfio" "vfio_iommu_type1" ];

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "ydotool" ];
    password = username;
  };

  programs.ydotool.enable = true;

  services.xserver.enable = true;
  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  services.displayManager = {
    autoLogin = {
      enable = true;
      user = username;
    };
  };

  virtualisation.sharedDirectories = {
    host-projects = {
      source = "/home/valtrois/videos";
      target = "/mnt/host-projects/videos";
    };
  };

  environment.shellAliases = {
    vim = "nvim --listen /tmp/nvim.pipe -c 'set paste'";
    src = "source .venv/bin/acrivate";
  };

  environment.systemPackages = with pkgs; [ 
    neovim
    curl 
    git 
    kitty
    python3
    python3Packages.pip
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";

  home-manager.users.${username} = { pkgs, ... }: {
      home.stateVersion = "25.11";

      programs.kitty.enable = true;
      programs.kitty.settings = {
        font_size="9.0";
        cursor_trail="1";
        cursor_trail_start_threshold="0";
        cursor_trail_decay="0.05 0.1";
      };
  };
}
