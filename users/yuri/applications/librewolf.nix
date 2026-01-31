{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    programs.librewolf =
      let
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
        commonSettings = {
          "accessibility.browsewithcaret_shortcut.enabled" = false;
          "accessibility.typeaheadfind.flashBar" = 0;
          "browser.bookmarks.restore_default_bookmarks" = false;
          "browser.startup.page" = 3;
          "browser.toolbars.bookmarks.visibility" = "never";
          "sidebar.visibility" = "hide-sidebar";
          "webgl.disabled" = false;
        };
      in
      {
        enable = true;
        package = if config.localhost.installLibrewolf then pkgs.librewolf else null;
        languagePacks = lib.optionals (specialArgs.type == "nixos") [
          "en-GB"
          "de"
        ];
        policies = {
          ExtensionSettings = {
            "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/file/4664623/bitwarden_password_manager-2025.12.1.xpi";
              installation_mode = "force_installed";
            };
            "uBlock0@raymondhill.net" = {
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
              private_browsing = true;
            };
          };
        };
        profiles.personal = lib.mkIf config.localhost.personal.enable {
          inherit search;
          isDefault = true;
          settings = commonSettings // { };
        };
        profiles.work = lib.mkIf config.localhost.work.enable {
          inherit search;
          isDefault = true;
          settings = commonSettings // {
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
          };
        };
      };
  };
}
