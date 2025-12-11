{ config, pkgs, ... }:

{
  services.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    audio.enable = true;
    jack.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    pavucontrol
  ];
}
