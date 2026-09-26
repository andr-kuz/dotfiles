{ pkgs, lib, ... }:
# https://raw.githubusercontent.com/AlfredoSequeida/hints/refs/heads/main/install.sh
let
  trigger = builtins.pathExists /var/tmp/hints.enable;

  hintsVersion = "0.1.1";

  hintsPkg = pkgs.python3Packages.buildPythonApplication rec {
    pname = "hints";
    version = hintsVersion;

    # Явно указываем Nix использовать старый setuptools, так как в проекте нет современного `pyproject.toml`, только устаревший `setup.py`
    build-system = with pkgs.python3Packages; [ setuptools ];
    pyproject = true;

    # Отключаем валидатор версий зависимостей pip/wheel из-за ошибки
    # > Checking runtime dependencies for hints-0.1.1-py3-none-any.whl
    #   >   - pygobject==3.50.0 not satisfied by version 3.56.3
    dontCheckRuntimeDeps = true;

    src = pkgs.fetchFromGitHub {
      owner = "AlfredoSequeida";
      repo = "hints";
      tag = version; 
      hash = "sha256-JhHoXnZeGBu9m2o3cRUky6Nc5uSc1DkS9V8420jEw+o="; 
    };

    # Отключаем проблемный PostInstallCommand, который ломает сборку в песочнице Nix
    # Мы сделаем его работу (создание сервиса) декларативно ниже средствами Home Manager
    preBuild = ''
      export HINTS_EXPECTED_BIN_DIR="$out/bin"
      sed -i '/cmdclass=/d' setup.py
    '';
    ## preBuild REPLACEMENT
    # Используем правильный патч, полностью вырезающий кастомный класс установки,
    # так как системный systemd-сервис мы сделаем декларативно ниже.
    # postPatch = ''
    #   substituteInPlace setup.py \
    #     --replace 'cmdclass={"install": PostInstallCommand},' ""
    # '';

    # Библиотеки, необходимые для компиляции и работы
    buildInputs = with pkgs; [
      glib
      dbus
      gtk3
      gtk-layer-shell
      libwnck         # опционально для не-wayland протоколов
    ];

    # Системные зависимости для компиляции C-биндингов (PyGObject, dbus-python)
    nativeBuildInputs = with pkgs; [
      gobject-introspection
      pkg-config
      wrapGAppsHook3
    ];

    # Python-зависимости, которые мы нашли в setup.py
    propagatedBuildInputs = with pkgs.python3Packages; [
      pygobject3
      pillow
      pyscreenshot
      opencv4      # opencv-python
      evdev
      dbus-python
      rich
    ];

    dontWrapGApps = true; # Отключаем стандартный шаг, чтобы сделать кастомный wrap с makeWrapperArgs
    preFixup = ''
      makeWrapperArgs+=(
        "''${gappsWrapperArgs[@]}"
        --set GDK_BACKEND "wayland"
        --prefix PATH : ${lib.makeBinPath [ pkgs.grim ]}
      )
    '';

    meta = with lib; {
      description = "Navigate GUI applications in Linux without a mouse";
      homepage = "https://github.com/AlfredoSequeida/hints";
      license = licenses.gpl3Only;
    };
  };
in
lib.mkIf trigger {
  # ydotool dependency
  programs.ydotool.enable = true;
  users.users.valtrois.extraGroups = [ "ydotool" "input" ];

  # Включаем шину доступности (Accessibility Bus), без неё hints не сможет читать GUI-элементы
  services.gnome.at-spi2-core.enable = true;

  environment.systemPackages = [ 
    hintsPkg 
  ];

  # Декларативная замена того, что делал setup.py (создание systemd-сервиса)
  # https://raw.githubusercontent.com/AlfredoSequeida/hints/refs/heads/main/setup.py
  ## THIS OPTION PROBLEM:
  ## running `hints` does nothing
  systemd.user.services.hintsd = {
    description = "Hints daemon (User-space service for Wayland)";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];

    serviceConfig = {
      Type = "simple";
      ExecStart = "${hintsPkg}/bin/hintsd";
      Restart = "always";
      RestartSec = "2s";
      # SupplementaryGroups = [ "input" "ydotool" ]; 
      Environment = [
        "XDG_SESSION_TYPE=wayland"
        "XDG_CURRENT_DESKTOP=niri"
      ];
    };
  };

  ## THIS OPTION PROBLEM:
  ## running `hints` displays overlay but entering any input results in
  ## client.connect(UNIX_DOMAIN_SOCKET_FILE): No such file or directory
  # systemd.services.hintsd = {
  #   description = "Hints daemon (System-wide service running as user)";
  #   wantedBy = [ "graphical-session.target" ];
  #   after = [ "graphical-session.target" ];
  #
  #   serviceConfig = {
  #     Type = "simple";
  #     User = "valtrois"; 
  #     ExecStart = "${hintsPkg}/bin/hintsd";
  #     Restart = "always";
  #     RestartSec = "2s";
  #     SupplementaryGroups = [ "input" "ydotool" ]; 
  #     Environment = [
  #       "XDG_SESSION_TYPE=wayland"
  #       "XDG_CURRENT_DESKTOP=niri"
  #     ];
  #   };
  # };
}
