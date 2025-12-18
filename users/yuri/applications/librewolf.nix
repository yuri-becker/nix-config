{ ... }:
{
  programs.librewolf = {
    enable = true;
    languagePacks = [
      "en-GB"
      "de"
    ];
    profiles.work = {
      search = {
        force = true;
        default = "Kagi";
        privateDefault = "Kagi";
        engines = {
          Kagi = {
            name = "Kagi";
            urls = [ { template = "https://kagi.com/search?q={searchTerms}"; } ];
            icon = "https://kagi.com/favicon.ico";
          };
          mynixos = {
            name = "MyNixOS";
            urls = [ { template = "https://mynixos.com/search?q={searchTerms}"; } ];
            icon = "https://mynixos.com/favicon.ico";
            definedAliases = [ "@m" ];
          };
          noogle = {
            name = "Noogλe";
            urls = [ { template = "https://noogle.dev/q?term={searchTerms}"; } ];
            icon = "https://noogle.dev/favicon.ico";
            definedAliases = [ "@n" ];
          };
        };
      };
      settings = {
        "accessibility.browsewithcaret_shortcut.enabled" = false;
        "accessibility.typeaheadfind.flashBar" = 0;
        "browser.bookmarks.restore_default_bookmarks" = false;
        "browser.newtabpage.activity-stream.newtabWallpapers.wallpaper" = "dark-fox-anniversary";
        "browser.newtabpage.pinned" = [
          {
            "url" = "https://gitlab.com/";
            "label" = "Gitlab";
          }
          {
            "url" = "https://gitlab.alt.coop/";
            "label" = "Gitlab (cac)";
          }
          {
            "url" = "https://cloud.alt.coop/apps/deck/board/4";
            "label" = "Todo";
          }
          {
            "url" = "https://cloud.alt.coop/";
            "label" = "Nextcloud";
          }
        ];
        "browser.startup.page" = 3;
        "browser.toolbars.bookmarks.visibility" = "never";
        "sidebar.visibility" = "hide-sidebar";
        "webgl.disabled" = false;
      };
    };
  };
}
