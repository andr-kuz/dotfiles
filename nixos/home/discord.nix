{ lib, ... }: 
let
  trigger = builtins.pathExists /var/tmp/discord.enable;
in
lib.mkIf trigger
{
  programs.discord = {
    enable = true;
  };
}
