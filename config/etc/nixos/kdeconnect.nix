{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdeconnect.enable;

  hypr-kdeconnect-fix = pkgs.stdenv.mkDerivation {
    pname = "hypr-kdeconnect-fix";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "gfhdhytghd";
      repo = "hypr-kdeconnect-fix";
      rev = "master"; # or specific commit hash
      sha256 = "sha256-VcXxVtlnkPjO6l0ky/n+0qa87Uc3c8hRM0twfgl+AiM="; # replace with actual hash
    };

    nativeBuildInputs = with pkgs; [
      cmake
      ninja
      pkg-config
      qt6.wrapQtAppsHook
    ];

    buildInputs = with pkgs; [
      qt6.qtbase
      wayland
      libxkbcommon
      libei
      xdg-desktop-portal
    ];
  };
in
lib.mkIf trigger {
  programs.kdeconnect.enable = true;
  environment.systemPackages = [ 
    hypr-kdeconnect-fix 
    pkgs.wl-clipboard
  ];
}
