{...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        locked-title = true;
        font = "Input Mono:size=12";
        pad = "10x6 center";
      };
      colors = {
        background = "000000";
        foreground = "ffffff";
      };
    };
  };
}
