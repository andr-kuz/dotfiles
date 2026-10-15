{ pkgs, inputs, ... }:

let
  unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
  };
in
{
  services.hypridle = {
    enable = true;
    package = unstable.hypridle;
  };
}
