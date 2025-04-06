{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    hostname = "strontium-pc";
    user = "anon";
    pkgs = import nixpkgs {
      inherit system;
    };
  in {
    nixosConfigurations = {
      ${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [ ./system/configuration.nix ];
      };
    };
    homeConfigurations = {
      ${user} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [ ./home/home.nix ];
      };
    };
  };
}
