{ lib, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    # Optional Zsh features
    enableBashCompletion = true;
    autosuggestions.enable = true;
    syntaxHighlighting.enable = true;

    # Source the Powerlevel10k theme
    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # Load your p10k configuration file if it exists
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
    '';
  };
  users.users.valtrois.shell = pkgs.zsh;
}
