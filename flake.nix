{
  description = "NixOS config";

  inputs = {
    nixpkgs.follows = "nixpkgs-unstable";

    nixpkgs-unstable.url = "nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "nixpkgs/nixos-26.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dotfiles = {
      url = "github:b-swist/dots";
      flake = false;
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    pedantix = {
      url = "github:Swarsel/pedantix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        treefmt-nix.follows = "treefmt-nix";
      };
    };
  };

  outputs =
    {
      home-manager,
      nixpkgs,
      self,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
          input-fonts.acceptLicense = true;
        };
        overlays = [ self.overlays.default ];
      };
    in
    {
      overlays.default = final: prev: import ./pkgs { inherit final prev; };
      nixosModules.default = import ./modules/nixos;
      homeModules.default = import ./modules/home;

      formatter.${system} = treefmt-nix.lib.mkWrapper pkgs {
        imports = [ inputs.pedantix.treefmtModules.default ];
        projectRootFile = "flake.nix";
        programs.pedantix = {
          enable = true;
          package = pkgs.symlinkJoin {
            name = "pedantix";
            paths = [ pkgs.pedantix ];
            nativeBuildInputs = [ pkgs.makeWrapper ];
            postBuild = ''
              wrapProgram $out/bin/pedantix \
                --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.nixfmt ]}
            '';
            meta.mainProgram = "pedantix";
          };
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
          self.homeModules.default
        ];
        extraSpecialArgs = { inherit inputs; };
      };
    };
}
