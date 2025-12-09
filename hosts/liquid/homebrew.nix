{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    brews = [
      "fileicon" # not in nixpkgs
      "mas" # needed for masApps
    ];
    casks = [
      "affinity"
      "beeper" # nixpkgs doesnt have darwin
      "burp-suite"
      "freecad" # nixpkgs doenst have darwin
      "gimp" # suddenly marked as incompatbile for darwin
      "jordanbaird-ice"
      "nextcloud" # nixpkgs doesnt have darwin
      "obs"
      "obsidian" # Wanna get rid of anyway
      "onlyoffice" # nixpkgs doesnt have darwin
      "orion" # not in nixpkgs
      "prusaslicer" # webkitgtk marked as broken
      "sony-ps-remote-play" # not in nixpkgs (but in nur)
      "teamspeak-client@beta" # nixpkgs doenst have darwin
      "xppen-pentablet" # not in nixpkgs
    ];
    masApps = {
      AusweisApp = 948660805;
      "Hand Mirror" = 1502839586;
      Keynote = 409183694;
      Magnet = 441258766;
      Numbers = 409203825;
      Transporter = 1450874784;
      WireGuard = 1451685025;
      XCode = 497799835;
      "Yubico Authenticator" = 1497506650;
    };
  };
}
