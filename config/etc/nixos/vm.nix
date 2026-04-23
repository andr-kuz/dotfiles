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

  # ========== DISPLAY ==========
  # Handled at launch time: ~/vm/bin/run-nixos-vm -display gtk,grab-on-hover=on
  # Do NOT set -display here to avoid conflicts with NixOS defaults.

  # ========== VIRTUALISATION ==========
  virtualisation = {
    diskSize = 20480;           # 20 GB
    memorySize = 8192;          # 8 GB RAM — set explicitly
    cores = 4;                  # Cleaner than -smp in qemu.options

    qemu = {
      diskInterface = "virtio";

      options = [
        "-cpu" "host,topoext"        # topoext exposes AMD topology (important for Zen)
        "-enable-kvm"
        "-machine" "q35,accel=kvm"   # q35 is modern, better than i440fx default

        # Display — virtio-gpu is best for AMD host without GPU passthrough
        "-vga" "none"
        "-device" "virtio-vga-gl"    # virtio-gpu with OpenGL acceleration

        "-display" "gtk,gl=on,grab-on-hover=off"

        # SPICE agent for clipboard/resize (remove if using virtio-vga-gl only)
        "-device" "virtio-serial-pci"
        "-device" "virtserialport,chardev=spicechannel0,name=com.redhat.spice.0"
        "-chardev" "spicevmc,id=spicechannel0,name=vdagent"

        # Balloon driver for dynamic memory
        "-device" "virtio-balloon"

        # Better RNG (avoids entropy starvation)
        "-object" "rng-random,id=rng0,filename=/dev/urandom"
        "-device" "virtio-rng-pci,rng=rng0"
      ];

      # Leave networkingOptions at default — NixOS handles this correctly
    };
  };

  # ========== BOOT ==========
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.kernelParams = [
    "elevator=none"         # virtio-blk doesn't need an I/O scheduler
    "console=ttyS0"         # Serial console for debugging if display fails
  ];

  # Guest kernel modules only — no kvm-amd (that's host-only)
  boot.initrd.kernelModules = [ "virtio_gpu" "virtio_scsi" "virtio_blk" ];
  boot.kernelModules = [ "virtio_pci" "virtio_net" ];

  # ========== GUEST SERVICES ==========
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # ========== CPU GOVERNOR ==========
  powerManagement.cpuFreqGovernor = "performance";

  # ========== VIDEO ACCELERATION IN GUEST ==========
  hardware.graphics.enable = true;

  # ========== THE REST ==========

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

  programs.neovim = {
    enable = true;

    extraLuaConfig = ''
      vim.opt.swapfile = false
      vim.opt.backup = false
    '';
  };

  virtualisation.sharedDirectories = {
    host-projects = {
      source = "/home/valtrois/videos";
      target = "/mnt/host-projects/videos";
    };
  };

  environment.shellAliases = {
    vim = "nvim --listen /tmp/nvim.pipe -c 'set paste'";
    src = "source .venv/bin/activate";
  };

  environment.systemPackages = with pkgs; [ 
    curl 
    git 
    kitty
    google-chrome
    python3
    python3Packages.pip
  ];

  nix.settings.experimental-features = ["nix-command" "flakes"];
  system.stateVersion = "25.11";

  home-manager.users.${username} = { pkgs, ... }: {
      home.stateVersion = "25.11";

      programs.kitty.enable = true;
      programs.kitty.settings = {
        font_size="12.0";
        cursor_trail="1";
        cursor_trail_start_threshold="0";
        cursor_trail_decay="0.05 0.1";
      };
  };
}
