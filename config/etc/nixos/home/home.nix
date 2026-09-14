{ 
  config
  , pkgs
  , inputs
  #, homeDirectory
  #, username
  , ...
}:

let
  myGithub = "andr-kuz";
in

{
  #home = {
    #inherit homeDirectory username;
  #};

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  home.stateVersion = "25.11";  # Did you read the comment?
  home.username = "valtrois";
  home.homeDirectory = "/home/valtrois";

  nixpkgs.config.allowUnfree = true;
  imports = [
    ./programs/waybar.nix
    ./programs/telegram.nix
    ./programs/nvim.nix
    ./programs/yazi.nix
    ./programs/brightnessctl.nix
    ./programs/obsidian.nix
    ./programs/rnote.nix
  ];

  home.packages = with pkgs; [
    qbittorrent
    wl-clipboard
    google-chrome
    alacritty
    fuzzel
    wofi
    zsh-powerlevel10k
    meslo-lgs-nf  # Powerlevel10k icon font
    hypridle
    hyprpaper
    hyprshot
    # vital
  ];

  home.activation.myUserScript = ''
    ${pkgs.rustup}/bin/rustup default stable # set rust defaul channel
  '';

  services.syncthing = {
    enable = true;
    # https://wiki.nixos.org/wiki/Syncthing
    # openDefaultPorts = true;
    # settings = {
    #   gui = {
    #     user = "myuser";
    #     password = "mypassword";
    #   };
    #   devices = {
    #     "device1" = { id = "DEVICE-ID-GOES-HERE"; };
    #     "device2" = { id = "DEVICE-ID-GOES-HERE"; };
    #   };
    #   folders = {
    #     "Documents" = {
    #       path = "/home/myusername/Documents";
    #       devices = [ "device1" "device2" ];
    #     };
    #     "Example" = {
    #       path = "/home/myusername/Example";
    #       devices = [ "device1" ];
    #       ignorePerms = false; # Enable file permission syncing
    #     };
    #   };
    # };
  };

  home.file = {
    ".config/yazi/keymap.toml" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/yazi/keymap.toml";
    };
    ".zshenv" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh/.zshenv";
    };
    ".zshrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh/.zshrc";
    };
    ".bash_functions" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/.bash_functions";
    };
    ".gitconfig" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/.gitconfig";
    };
  };

  xdg.configFile = {
    "niri" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/niri";
      recursive = true;
      force = true;
    };

    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/hypr";
      recursive = true;
      force = true;
    };

    "kitty" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/kitty";
      recursive = true;
      force = true;
    };

    "tmux" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/tmux";
      recursive = true;
      force = true;
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "awakum";
        email = "awakum192@gmail.com";
      };
      init.defaultBranch = "main";
    };
  };
}
