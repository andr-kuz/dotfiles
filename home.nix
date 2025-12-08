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

  home.packages = with pkgs; [
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
  ];

  # services.lsp.servers.clangd.enable = true;

  home.file.".zshenv" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh/.zshenv";
  };

  xdg.configFile = {
    "zsh" = {
      source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/.config/zsh";
      recursive = true;
    };
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
