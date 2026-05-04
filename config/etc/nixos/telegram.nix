{ lib, pkgs, ... }:
let
  trigger = builtins.pathExists /var/tmp/telegram.enable;
in

lib.mkIf trigger {
    environment.systemPackages = with pkgs; [
      telegram-desktop
    ];
}

# # older home made telegram source build
# let
#   trigger = builtins.pathExists /var/tmp/telegram.enable;
#
#   telegramSrc = pkgs.fetchgit {
#     url = "https://github.com/andr-kuz/telegram-desktop";
#     rev = "db3fc57";
#     hash = "sha256-cIhQ63cp1rwO8jM1cMQdU9WlsTpNAiMKeC9H9PIVx4w=";
#   };
#
#   # Use KDE6 packages
#   kde6 = pkgs.kdePackages;
#
#   # Build the unwrapped package
#   unwrapped = pkgs.callPackage (telegramSrc + "/unwrapped.nix") {
#     inherit (pkgs)
#       stdenv fetchFromGitHub callPackage pkg-config cmake ninja
#       clang python3 lz4 xxHash ffmpeg_6 protobuf openalSoft
#       minizip-ng range-v3 tl-expected hunspell gobject-introspection
#       rnnoise microsoft-gsl boost ada libavif libheif libjxl
#       libicns nix-update-script;
#
#     qtbase = kde6.qtbase;
#     qtsvg = kde6.qtsvg;
#     qtwayland = kde6.qtwayland;
#     kcoreaddons = kde6.kcoreaddons;
#
#     tdlib = pkgs.tdlib;
#     tg_owt = pkgs.callPackage (telegramSrc + "/tg_owt.nix") { 
#       inherit (pkgs) stdenv; 
#     };
#   };
#
#   # Build the main package wrapper
#   custom-telegram = pkgs.callPackage (telegramSrc + "/default.nix") {
#     inherit unwrapped;
#
#     qtbase = kde6.qtbase;
#     qtimageformats = kde6.qtimageformats;
#     qtsvg = kde6.qtsvg;
#     qtwayland = kde6.qtwayland;
#     kimageformats = kde6.kimageformats;
#
#     wrapQtAppsHook = kde6.wrapQtAppsHook;
#     wrapGAppsHook3 = pkgs.wrapGAppsHook3;
#
#     inherit (pkgs)
#       geoclue2
#       glib-networking
#       webkitgtk_4_1;
#
#     withWebkit = true;
#   };
# in
# lib.mkIf trigger {
#   environment.systemPackages = [ 
#       custom-telegram 
#     ];
# }
