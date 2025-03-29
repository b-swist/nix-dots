{ ... }:

{
  programs.bash = {
    enable = true;
    initExtra = ''
      PS1="\w > "
    '';
    historyControl = [ "erasedups" ];
    shellAliases = {
      ll = "ls -lAh";
      ".." = "cd ..";
    };
  };
}
