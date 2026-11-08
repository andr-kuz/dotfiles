{ pkgs, ... }:

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


  # # Stop static noise from unplugged motherboard input source
  # services.pipewire.wireplumber.extraConfig."disable-analog-input" = {
  #   "monitor.alsa.rules" = [
  #     {
  #       matches = [
  #         { "node.name" = "alsa_input.pci-0000_0c_00.4.analog-stereo"; }
  #       ];
  #       actions = {
  #         update-props = {
  #           "node.disabled" = true;
  #         };
  #       };
  #     }
  #   ];
  # };
}
