{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    copyq
    wl-clipboard
  ];
}
