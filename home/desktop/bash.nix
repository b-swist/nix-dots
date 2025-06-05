{config, ...}: {
  programs.bash = {
    enable = true;

    historyFile = "${config.xdg.stateHome}/bash/history";
    historyIgnore = ["ls"];
    historyControl = [
      "ignoreboth"
      "erasedups"
    ];

    initExtra = ''
      PS1="\w > "
    '';

    shellOptions = [
      "autocd"
      "cdspell"
      "checkwinsize"
      "extglob"
      "globstar"
      "histappend"
    ];
    shellAliases = {
      ll = "ls -lAh";
      ".." = "cd ..";
      wget = "wget --hsts-file=${config.xdg.dataHome}/wget-hsts";
    };
  };
}
