{ ... }: {
  programs.foot = {
    enable = true;

    settings.main = {
      font = "Input Mono:size=11";
      locked-title = true;
      pad = "10x6 center";
    };
  };
}
