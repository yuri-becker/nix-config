{ pkgs, ... }:
{
  system.primaryUser = "yuri";
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults.NSGlobalDomain = {
    AppleInterfaceStyle = "Dark";
    ApplePressAndHoldEnabled = false;
    "com.apple.keyboard.fnState" = true;
    "com.apple.sound.beep.feedback" = 0;
    "com.apple.trackpad.forceClick" = true;
    "com.apple.trackpad.scaling" = 1.0;
    NSAutomaticCapitalizationEnabled = false;
    NSAutomaticPeriodSubstitutionEnabled = true;
    NSAutomaticSpellingCorrectionEnabled = false;
    _HIHideMenuBar = false;
  };

  system.defaults.".GlobalPreferences" = {
    "com.apple.mouse.scaling" = 1.5;
    "com.apple.sound.beep.sound" = "/System/Library/Sounds/Hero.aiff";
  };

  system.defaults.dock = {
    autohide = true;
    autohide-delay = 0.0;
    tilesize = 64;
    magnification = false;
    mineffect = "scale";
    minimize-to-application = true;
    orientation = "bottom";
    show-recents = false;
    static-only = false;
    wvous-bl-corner = 1;
    wvous-br-corner = 1;
    wvous-tl-corner = 1;
    wvous-tr-corner = 1;

    persistent-apps = [
      "/Applications/Orion.app"
      "${pkgs.feishin}/Applications/feishin.app"
      "${pkgs.kitty}/Applications/kitty.app"
      "/System/Applications/Calendar.app"
      {
        spacer.small = true;
      }
      "${pkgs.vesktop}/Applications/Vesktop.app"
      "/Applications/Beeper Desktop.app"
      "/Applications/Teamspeak.app"
      {
        spacer.small = true;
      }
    ];
  };
  system.defaults.finder = {
    AppleShowAllFiles = true;
    ShowPathbar = true;
    ShowStatusBar = true;
  };
  system.defaults.WindowManager = {
    AppWindowGroupingBehavior = true;
    AutoHide = false;
    EnableTiledWindowMargins = false;
    EnableTilingByEdgeDrag = false; # Still using magnet until shortcuts are remappable
    GloballyEnabled = false;
    StandardHideDesktopIcons = false;
    StandardHideWidgets = false;
  };
  system.defaults.iCal = {
    "first day of week" = "Monday";
  };
  system.defaults.menuExtraClock = {
    FlashDateSeparators = false;
    IsAnalog = false;
    Show24Hour = true;
    ShowAMPM = false;
    ShowDayOfMonth = true;
    ShowDayOfWeek = true;
    ShowSeconds = false;
  };
}
