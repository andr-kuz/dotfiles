{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/obs-studio.enable;
in
lib.mkIf trigger {
  programs.obs-studio = {
    enable = true;

    # optional Nvidia hardware acceleration
    # package = (
    #   pkgs.obs-studio.override {
    #     cudaSupport = true;
    #   }
    # );

    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi #optional AMD hardware acceleration
      obs-gstreamer
      obs-vkcapture
    ];
  };

  home.packages = [ 
    pkgs.obs-cmd 
  ];

  home.file.".config/obs-studio/basic/profiles/Untitled/basic.ini".text = ''
    [Hotkeys]
    OBSBasic.StartRecording=[{"key": "OBS_KEY_R", "modifiers": {"shift": true, "super": true}}]
    OBSBasic.StopRecording=[{"key": "OBS_KEY_R", "modifiers": {"shift": true, "super": true}}]
  '';
}
