{
  description = "NixOS config";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    # nixpkgs-stable.url = "nixpkgs/nixos-24.11";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    firefox-addons = {
      url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-nvim = {
      url = "github:b-swist/nix-nvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    settings = {
      system = "x86_64-linux";
      hostname = "strontium-pc";
      username = "anon";
    };
    pkgs = import nixpkgs {
      inherit (settings) system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations = {
      ${settings.hostname} = nixpkgs.lib.nixosSystem {
        inherit (settings) system;
        specialArgs = {inherit settings;};
        modules = [./system/configuration.nix];
      };
    };
    homeConfigurations = {
      ${settings.username} = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = {inherit inputs settings;};
        modules = [./home];
      };
    };
  };
}
