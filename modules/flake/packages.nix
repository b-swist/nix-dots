{ lib, self, ... }:
let
  mkPackages =
    src: pkgs:
    lib.mapAttrs' (
      name: type: lib.nameValuePair name (pkgs.callPackage (src + "/${name}/package.nix") { })
    ) (lib.filterAttrs (name: type: type == "directory") (builtins.readDir src));

  ## i'd rather use pipe operators here but pedantix throws errors
  ## leaving it here for future reference
  # mkPackages =
  #   src: pkgs:
  #   builtins.readDir src
  #   |> lib.filterAttrs (_: type: type == "directory")
  #   |> lib.mapAttrs' (
  #     name: lib.nameValuePair name (pkgs.callPackage (src + "/${name}/package.nix") { })
  #   );
in
{
  perSystem = { pkgs, ... }: {
    packages = mkPackages (self + "/pkgs") pkgs;
  };
}
