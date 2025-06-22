{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "affinity-designer@1"
      "balenaetcher"
      "beeper"
      "burp-suite"
      "freecad"
      "jordanbaird-ice"
      "languagetool"
      "monero-wallet"
      "nextcloud"
      "obs"
      "obsidian"
      "onlyoffice"
      "orion"
      "playcover-community"
      "prusaslicer"
      "raspberry-pi-imager"
      "raycast"
      "sony-ps-remote-play"
      "vlc"
      "whisky"
      "whoozle-android-file-transfer"
      "yubico-authenticator"
    ];
  };
}
