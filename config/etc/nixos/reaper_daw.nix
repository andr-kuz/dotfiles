{ lib, pkgs, ... }: 

let
  trigger = builtins.pathExists /var/tmp/reaper_daw.enable;
in
lib.mkIf trigger {
  environment.systemPackages = with pkgs; [
    reaper
    yabridge  # for Windows VSTs 
    carla     # plugin host
  ];

  # Enable Realtime Audio Permissions
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Optional: Define standard VST/LV2 paths
  environment.variables = {
    VST_PATH = "$HOME/.vst";
    VST3_PATH = "$HOME/.vst3";
    LV2_PATH = "$HOME/.lv2";
  };
}
