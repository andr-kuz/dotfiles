{ 
  config
  , pkgs
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
  home.stateVersion = "25.11";
  home.username = "valtrois";
  home.homeDirectory = "/home/valtrois";

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    wl-clipboard
    google-chrome
    kitty
    wofi
    zsh-powerlevel10k
    meslo-lgs-nf  # Powerlevel10k icon font
    hypridle
    git
    neovim
    # neovim plugins requirements
    nodejs
    yarn
    gcc
    clang-tools
    pyright
    rustup
    unzip
    libxkbfile
    python3
    fzf
    ripgrep
    (python3.withPackages (ps: with ps; [
      debugpy
    ]))
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
    ".zshenv" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh/.zshenv";
    };
    ".zshrc" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/zsh/.zshrc";
    };
  };

  xdg.configFile = {
    "nvim" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/nvim";
      recursive = true;
      force = true;
    };

    "hypr" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/config/hypr";
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
