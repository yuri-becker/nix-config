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
      "mas" # needed for masApps
    ];
    casks = [
      "affinity"
      "beeper" # nixpkgs doesnt have darwin
      "freecad" # nixpkgs doenst have darwin
      "nextcloud" # nixpkgs doesnt have darwin
      "obsidian" # Wanna get rid of anyway
      "orion" # not in nixpkgs
      "prusaslicer" # webkitgtk marked as broken
      "teamspeak-client@beta" # nixpkgs doenst have darwin
    ];
    masApps = {
      AusweisApp = 948660805;
      "Hand Mirror" = 1502839586;
      Magnet = 441258766;
      WireGuard = 1451685025;
      XCode = 497799835;
    };
  };
}
