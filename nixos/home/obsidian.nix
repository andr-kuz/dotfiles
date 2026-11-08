{ lib, ... }: 
let
  trigger = builtins.pathExists /var/tmp/obsidian.enable;
in
lib.mkIf trigger
{
  programs.obsidian = {
    enable = true;
  };
}
