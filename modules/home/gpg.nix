{
  flake.homeModules.gpg =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      program.git.signing = {
        format = "openpgp";
        signByDefault = lib.mkDefault true;
      };
      programs.gpg = {
        enable = true;
        homedir = "${config.xdg.dataHome}/gnupg";
      };

      services.gpg-agent = {
        enable = lib.mkDefault true;
        pinentry.package = lib.mkDefault pkgs.pinentry-tty;
      };
    };
}
