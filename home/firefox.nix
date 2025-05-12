{
  inputs,
  settings,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.${settings.username} = {
      search.default = "ddg";
      settings = {
        "sidebar.verticalTabs" = true;
        "browser.ml.chat.enabled" = false;
        "sidebar.main.tools" = "history";
      };
      extensions.packages = with inputs.firefox-addons.packages.${settings.system}; [
        ublock-origin
        bitwarden
        darkreader
        sponsorblock
        clearurls
      ];
    };
  };
}
