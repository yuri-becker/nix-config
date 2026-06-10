{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # cleanup = "uninstall";
    };
    brews = [
      "mas" # needed for masApps
    ];
    casks = [
      "affinity"
      "freecad" # nixpkgs doenst have darwin
      "nextcloud" # nixpkgs doesnt have darwin
      "obsidian" # Wanna get rid of anyway
      "orion" # not in nixpkgs
      "prusaslicer" # webkitgtk marked as broken
      "rawtherapee" # nixpkgs build is broken on darwin
      "teamspeak-client@beta" # nixpkgs doenst have darwin
    ];
    masApps = {
      AusweisApp = 948660805;
      Cadence = 6748622506;
      Magnet = 441258766;
      WireGuard = 1451685025;
      XCode = 497799835;
    };
  };
}
