{ config, lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/reaper_daw.enable;
in
lib.mkIf trigger {
  # Install the user-facing packages natively inside the user profile
  home.packages = with pkgs; [
    reaper
    yabridge    # for Windows VSTs 
    yabridgectl # yabridgectl add ~/Audio/vsts && yabridge sync && yabridgectl status
  ];

  # Home Manager manages the extension file cleanly
  home.file.".config/REAPER/UserPlugins/reaper_reapack-x86_64.so" = {
    source = "${pkgs.reaper-reapack-extension}/lib/reaper_reapack-x86_64.so";
  };
}
