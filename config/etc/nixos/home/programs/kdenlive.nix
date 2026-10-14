{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdenlive.enable;
in
lib.mkIf trigger {
  home.packages = with pkgs; [
    (kdePackages.kdenlive.overrideAttrs (oldAttrs: {
      qtWrapperArgs = (oldAttrs.qtWrapperArgs or [ ]) ++ [
        "--prefix" "FREI0R_PATH" ":" "${pkgs.frei0r}/lib/frei0r-1"
        "--prefix" "LADSPA_PATH" ":" "${pkgs.ladspaPlugins}/lib/ladspa"
      ];
    }))
  ];
}
