{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.personal.enable {
    programs.vesktop = {
      enable = true;
      settings = {
        discordBranch = "stable";
        minimizeToTray = false;
        arRPC = true;
        splashColor = "rgb(205, 214, 244)";
        splashBackground = "#1e1e2e";
      };
      vencord.settings = {
        themeLinks = [
          "https://catppuccin.github.io/discord/dist/catppuccin-mocha.theme.css"
          "https://yuri-becker.github.io/relaxed-discord/RelaxedDiscord.theme.css"
        ];
        macosVibrancyStyle = "titlebar";
        plugins = {
          BadgeAPI.enabled = true;
          ChatInputButtonAPI.enabled = true;
          CommandsAPI.enabled = true;
          ContextMenuAPI.enabled = true;
          MemberListDecoratorsAPI.enabled = true;
          MessageAccessoriesAPI.enabled = true;
          MessageDecorationsAPI.enabled = true;
          MessageEventsAPI.enabled = true;
          NoticesAPI.enabled = true;
          NoTrack = {
            enabled = true;
            disableAnalytics = true;
          };
          Settings = {
            enabled = true;
            settingsLocation = "aboveActivity";
          };
          SupportHelper.enabled = true;
          BetterSettings = {
            enabled = true;
            disableFade = true;
            eagerLoad = true;
            organizeMenu = true;
          };
          CallTimer = {
            enabled = true;
            format = "human";
          };
          ClearURLs.enabled = true;
          Dearrow = {
            enabled = true;
            replaceElements = 0;
            dearrowByDefault = true;
            hideButton = false;
          };
          FixYoutubeEmbeds.enabled = true;
          ForceOwnerCrown.enabled = true;
          FriendsSince.enabled = true;
          ImageZoom = {
            enabled = true;
            size = 100;
            zoom = 2;
            saveZoomValues = true;
            nearestNeighbour = false;
            square = false;
          };
          MemberCount = {
            enabled = true;
            memberList = true;
            toolTip = true;
          };
          MoreKaomoji.enabled = true;
          NoF1.enabled = true;
          petpet.enabled = true;
          ShowConnections = {
            enabled = true;
            iconSpacing = 1;
            iconSize = 32;
          };
          SilentTyping = {
            enabled = true;
            isEnabled = true;
            showIcon = false;
            contextMenu = true;
          };
          Unindent.enabled = true;
          VencordToolbox.enabled = true;
          ViewIcons = {
            enabled = true;
            format = "webp";
            imgSize = "1024";
          };
          VolumeBooster.enabled = true;
          ImageLink.enabled = true;
          ReplaceGoogleSearch = {
            enabled = true;
            customEngineURL = "https://search.catboy.house/search?q=";
            customEngineName = "SearXNG";
          };
          UserSettingsAPI.enabled = true;
          YoutubeAdblock.enabled = true;
          DynamicImageModalAPI.enabled = true;
          FixImagesQuality.enabled = true;
          ExpressionCloner.enabled = true;
        };
        cloud = {
          authenticated = true;
          settingsSync = true;
          settingsSyncVersion = 1750556998010;
        };
      };
    };
    xdg.autostart.entries = [ "${pkgs.vesktop}/share/applications/vesktop.desktop" ];
  };
}
