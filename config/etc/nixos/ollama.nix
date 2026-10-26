{ config, pkgs, lib, ... }:
let
  trigger = builtins.pathExists /var/tmp/ollama.enable;
in
lib.mkIf trigger {
  # 1. Настройка сервиса Ollama под видеокарты AMD
  services.ollama = {
    enable = true;
    package = pkgs.ollama-rocm; 
    
    rocmOverrideGfx = "10.3.0"; 
    host = "0.0.0.0";
    port = 11434;
    environmentVariables = {
      HSA_OVERRIDE_GFX_VERSION = "10.3.0";
      HSA_ENABLE_SDMA = "0";
    };
  };

  # 2. Активация OpenCL / ROCm драйверов на системном уровне
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = [
      pkgs.rocmPackages.clr.icd # Драйвер для поддержки вычислений ROCm/OpenCL
    ];
  };

  # 3. Важнейший костыль для NixOS: ROCm ищет библиотеки по пути /opt/rocm
  systemd.tmpfiles.rules = [
    "L+ /opt/rocm - - - - ${pkgs.rocmPackages.clr}"
  ];

  # Загружаем модуль ядра для AMD
  boot.kernelModules = [ "amdgpu" ];

  # Жесткое правило IPTables: разрешаем входящие запросы на порт 11434 
  # ТОЛЬКО из локальной подсети Docker (обычно это 172.16.0.0/12)
  networking.firewall.extraCommands = ''
    iptables -A INPUT -p tcp --dport 11434 -s 172.16.0.0/12 -j ACCEPT
    iptables -A INPUT -p tcp --dport 11434 -s 172.17.0.0/16 -j ACCEPT
  '';
}
