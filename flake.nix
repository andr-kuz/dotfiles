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
    yazi-overlay.url = "github:sxyazi/yazi";
    krita-overlay.url = "github:NixOS/nixpkgs/nixos-25.11";
  };

  outputs = { 
    nixpkgs, 
    home-manager, 
    neovim-nightly-overlay,
    hints,
    yazi-overlay,
    krita-overlay,
    ... 
  }@inputs:
    let
      system = "x86_64-linux";
    in {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = system;
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs.overlays = [ (import ./nixos/overlays/xray.nix) ]; }
        ./nixos/configuration.nix
        /etc/nixos/hardware-configuration.nix
        home-manager.nixosModules.home-manager
        { home-manager.extraSpecialArgs = { inherit inputs; }; }
      ];
    };
  };
}
