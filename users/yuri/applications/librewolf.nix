{ config, lib, ... }:
let
  mkExtension =
    id:
    {
      private_browsing ? true,
      default_area ? "navbar",
    }:
    {
      inherit private_browsing default_area;
      install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
      installation_mode = "force_installed";
    };
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
    "extensions.install.requireBuiltInCerts" = false;
    "extensions.update.requireBuiltInCerts" = false;
    "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
    "privacy.resistFingerprinting" = false;
    "privacy.userContext.enabled" = false;
    "sidebar.visibility" = "hide-sidebar";
    "webgl.disabled" = false;
  };
in
{
  config = lib.mkIf config.localhost.enable {
    programs.librewolf = {
      enable = true;
      languagePacks = [
        "en-GB"
        "de"
      ];
      policies = {
        ExtensionSettings = {
          "{9bbf6724-d709-492e-a313-bfed0415a224}" = mkExtension "wave-accessibility-tool" { };
          "ATBC@EasonWong" = mkExtension "adaptive-tab-bar-colour" { };
          "addon@darkreader.org" = mkExtension "darkreader" { };
          "deArrow@ajay.app" = mkExtension "dearrow" { };
          "myallychou@gmail.com" = mkExtension "youtube-recommended-videos" { }; # Unhook
          "sponsorBlocker@ajay.app" = mkExtension "sponsorblock" { };
          "uBlock0@raymondhill.net" = mkExtension "ublock-origin" { default_area = "menupanel"; };
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
