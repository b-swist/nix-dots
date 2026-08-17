{ inputs, ... }: {
  imports = [
    inputs.treefmt-nix.flakeModule
    inputs.pedantix.flakeModules.default
  ];
  perSystem = { pkgs, ... }: {
    treefmt.programs.pedantix = {
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
}
