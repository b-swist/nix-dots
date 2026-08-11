{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:b-swist/dots";
      flake = false;
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pedantix = {
      url = "github:Swarsel/pedantix";
      inputs = {
        flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  outputs = {
    self,
    home-manager,
    nix-index-database,
    nixpkgs,
    treefmt-nix,
    ...
  } @ inputs:
   let
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        input-fonts.acceptLicense = true;
      };
      overlays = [
        self.overlays.default
      ];

      programs.nix-index.package =
        nix-index-database.packages.${system}.nix-index-with-small-db;
    };
  in {
    overlays.default = final: prev: import ./pkgs {inherit final prev;};
    nixosModules.default = import ./modules;

    formatter.${system} = treefmt-nix.lib.mkWrapper pkgs {
      imports = [inputs.pedantix.treefmtModules.default];
      projectRootFile = "flake.nix";
      programs.pedantix = {
        enable = true;
        settings = {
          preset = "nixos-module";
          attrs = {
            sort = false;
            flatten = true;
            merge = true;
          };
        };
      };
    };

    nixosConfigurations.rubidium = nixpkgs.lib.nixosSystem {
      inherit pkgs;
      modules = [
        ./configuration.nix
        self.nixosModules.default
      ];
    };

    homeConfigurations.snowy = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [
        ./home-manager.nix
        nix-index-database.homeModules.default
      ];
      extraSpecialArgs = {inherit inputs;};
    };
  };
}
