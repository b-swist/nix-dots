{...}: {
  programs.foot = {
    enable = true;
    settings = {
      main = {
        locked-title = true;
        font = "Maple Mono:size=11";
        pad = "10x6 center";
      };
      colors = {
        background = "000000";
        foreground = "ffffff";
      };
    };
  };
}
