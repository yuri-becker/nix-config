{
  config,
  lib,
  pkgs,
  ...
}:
let
  sopsFile = ./dolphin.secrets.yaml;
  secrets = {
    achievements.username = "dolphin/achievements/username";
    achievements.apiToken = "dolphin/achievements/api_token";
  };
  templates = {
    retroAchievements = "RetroAchievements.ini";
  };
  toINI = lib.generators.toINI { };
  cfg = config.programs.dolphin;
in
{
  options.programs.dolphin = {
    saveGamesLocation = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Nextcloud/Savegames/Dolphin";
    };
    romsLocation = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/Games/ROMs";
    };
  };
  config = lib.mkIf config.localhost.gaming.enable {
    sops.secrets = {
      "${secrets.achievements.username}".sopsFile = sopsFile;
      "${secrets.achievements.apiToken}".sopsFile = sopsFile;
    };
    home.packages = [ pkgs.dolphin-emu ];

    sops.templates."${templates.retroAchievements}".content = toINI {
      Achievements = {
        DiscordPresenceEnabled = true;
        Enabled = true;
        EncoreEnabled = false;
        HardcoreEnabled = true;
        ProgressEnabled = true;
        SpectatorEnabled = false;
        UnofficialEnabled = false;
        Username = config.sops.placeholder.${secrets.achievements.username};
        ApiToken = config.sops.placeholder.${secrets.achievements.apiToken};
        ChallengeIndicatorsEnabled = true;
        LeaderboardTrackerEnabled = true;
      };
    };

    xdg.configFile = {
      "dolphin-emu/RetroAchievements.ini" = {
        force = true;
        source = config.lib.file.mkOutOfStoreSymlink "${config.sops.templates.${templates.retroAchievements}.path
        }";
      };
      "dolphin-emu/GFX.ini" = {
        force = true;
        text = toINI {
          Enhancements = {
            PostProcessingShader = "";
          };
          Settings = {
            InterenalResolution = 3;
            wideScreenHack = true;
          };
        };
      };
      "dolphin-emu/Dolphin.ini" = {
        force = true;
        text = toINI {
          Analytics = {
            ID = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa";
            PermissionAsked = true;
          };
          BluetoothPassthrough.Enabled = false;
          Display.Fullscreen = true;
          General = {
            ISOPaths = 2;
            ISOPath0 = "${cfg.romsLocation}/Gamecube";
            ISOPath1 = "${cfg.romsLocation}/Wii";
            DumpPath = "${cfg.saveGamesLocation}/dump/";
            LoadPath = "${cfg.saveGamesLocation}/load/";
            NANDRootPath = "${cfg.saveGamesLocation}/nand/";
            ResourcePackPath = "${cfg.saveGamesLocation}/resource-packs/";
            WFSPath = "${cfg.saveGamesLocation}/wfs/";
            UseGameCovers = true;
            WiiSDCardPath = "${cfg.saveGamesLocation}/load/WiiSD.raw";
          };
          Core = {
            GCIFolderAPath = "${cfg.saveGamesLocation}/gci/USA";
            SelectedLanguage = 0;
            SerialPort1 = 0;
            SkipIPL = true;
            SlotA = 8;
            SlotB = 255;
            FallbackRegion = 1;
            GFXBackend = "Vulkan";
            WiimoteContinuousScanning = false;
            WiimoteControllerInterface = false;
            WiimoteEnableSpeaker = false;
            AudioStretch = false;
            AudioStretchMaxLatency = 80;
            DPL2Decoder = true;
            DPL2Quality = 0;
            DSPHLE = false;
          };
          DSP = {
            DSPThread = true;
            Backend = "Pulse";
            EnableJIT = true;
            MuteOnDisabledSpeedLimit = false;
          };
          GBA = {
            BIOS = "${cfg.saveGamesLocation}/GBA/gba_bios.bin";
            Rom1 = "";
            Rom2 = "";
            Rom3 = "";
            Rom4 = "";
            SavesInRomPath = false;
            SavesPath = "${cfg.saveGamesLocation}/GBA/Saves/";
            Threads = true;
          };
          Interface.ThemeName = "Clean Blue";
          Input.BackgroundInput = true;
          NetPlay.TraversalChoice = "direct";
          SDL_Hints = {
            SDL_JOYSTICK_DIRECTINPUT = 1;
            SDL_JOYSTICK_ENHANCED_REPORTS = 1;
            SDL_JOYSTICK_HIDAPI_COMBINE_JOY_CONS = 1;
            SDL_JOYSTICK_HIDAPI_PS5_PLAYER_LED = 0;
            SDL_JOYSTICK_HIDAPI_VERTICAL_JOY_CONS = 0;
            SDL_JOYSTICK_WGI = 0;
          };
        };
      };
    };
  };
}
