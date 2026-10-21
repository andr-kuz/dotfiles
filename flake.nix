{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hints = {
      url = "github:DemyCode/hints";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { 
    nixpkgs, 
    home-manager, 
    neovim-nightly-overlay,
    hints,
    ... 
  }@inputs:
    let
      system = "x86_64-linux";
    in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = { inherit inputs; };
      modules = [
        ./config/etc/nixos/configuration.nix
        /etc/nixos/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager.extraSpecialArgs = { inherit inputs; }; }
      ];
    };
  };
}
