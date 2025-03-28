{ ... }:

{
  programs.bash = {
    enable = true;
    shellAliases = {
      ll = "ls -lAh";
      ".." = "cd ..";
    };
  };
}
