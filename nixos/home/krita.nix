{ lib, pkgs, inputs, ... }:
let
  trigger = builtins.pathExists /var/tmp/krita.enable;
  # Pin Krita to 5.2.15: v6.0.2.1 has a font-family rendering bug
  kritaOverlay = inputs.krita-overlay.legacyPackages.${pkgs.system}.krita;
in
lib.mkIf trigger
{
  home.packages = with pkgs; [
    kritaOverlay
  ];
}
