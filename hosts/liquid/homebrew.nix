{ ... }:
{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "affinity-designer@1" # not in nixpkgs
      "balenaetcher" # not in nixpkgs (but in nur)
      "beeper" # nixpkgs doesnt have darwin
      "burp-suite"
      "freecad" # nixpkgs doenst have darwin
      "jordanbaird-ice"
      "languagetool"
      "monero-wallet"
      "nextcloud"
      "obs"
      "obsidian" # Wanna get rid of anyway
      "onlyoffice" # nixpkgs doesnt have darwin
      "orion" # not in nixpkgs
      "playcover-community"
      "prusaslicer" # webkitgtk marked as broken
      "raspberry-pi-imager"
      "sony-ps-remote-play" # not in nixpkgs (but in nur)
      "whoozle-android-file-transfer"
      "yubico-authenticator" # not in nixpkgs
      "xppen-pentablet" # not in nixpkgs
    ];
  };
}
