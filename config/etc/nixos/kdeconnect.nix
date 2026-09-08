{ lib, pkgs, ... }:

let
  trigger = builtins.pathExists /var/tmp/kdeconnect.enable;

  hypr-kdeconnect-fix = pkgs.stdenv.mkDerivation {
    pname = "hypr-kdeconnect-fix";
    version = "unstable";

    src = pkgs.fetchFromGitHub {
      owner = "gfhdhytghd";
      repo = "hypr-kdeconnect-fix";  # https://github.com/gfhdhytghd/hypr-kdeconnect-fix
      rev = "0bc47e676ae2d6964cec4020be9966bbe85985e6";  # or 'master'
      sha256 = "sha256-s8hWpEIyWpwW9w8t80Byqp+8jG0ChddtbDB7eJ/7ebA=";
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
