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
  ];
  home.activation.myUserScript = ''
    ${pkgs.rustup}/bin/rustup default stable # set rust defaul channel
  '';

  services.syncthing = {
    enable = true;
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
      source = builtins.fetchGit {
        url = "https://github.com/${myGithub}/nvim.git";
        ref = "master";
      };
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
