{
  description = "Home Manager configuration of valtrois";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixpkgs-wine.url = "github:NixOS/nixpkgs/8311011fcea909e0cc9684ada784dae080fbfb60"; 
  };

  outputs = { nixpkgs, home-manager, nixpkgs-wine, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations."valtrois" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # 2. This passes 'nixpkgs-wine' as a variable into your home.nix
        extraSpecialArgs = { inherit nixpkgs-wine; }; 
      };
    };
}
