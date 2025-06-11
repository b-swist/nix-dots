{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "nixpkgs/nixos-24.11";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-on-droid = {
      url = "github:nix-community/nix-on-droid/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    # firefox-addons = {
    #   url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    nix-nvim = {
      url = "github:b-swist/nix-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nix-on-droid,
    ...
  } @ inputs: let
    settings = {
      system = "x86_64-linux";
      hostname = "strontium";
      username = "anon";
    };
    pkgs = import nixpkgs {inherit (settings) system;};
  in {
    nixosConfigurations = {
      ${settings.hostname} = nixpkgs.lib.nixosSystem {
        inherit (settings) system;
        specialArgs = {inherit settings;};
        modules = [./system/desktop/configuration.nix];
      };
    };

    homeConfigurations = {
      ${settings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs settings;};
        modules = [./home/desktop];
      };
    };

    nixOnDroidConfigurations = {
      default = nix-on-droid.lib.nixOnDroidConfiguration {
        pkgs = import nixpkgs {system = "aarch64-linux";};
        modules = [./system/andorid/configuration.nix];
      };
    };
  };
}
