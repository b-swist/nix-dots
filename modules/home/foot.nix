{
  flake.homeModules.foot = { pkgs, ... }: {
    fonts.fontconfig.enable = true;

    home.packages = with pkgs; [
      nerd-fonts.symbols-only
      input-fonts
    ];

    programs.foot = {
      enable = true;

      settings.main = {
        font = "Input Mono:size=10";
        locked-title = true;
        pad = "10x6 center";
      };
    };
  };
}
