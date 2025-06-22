{ ... }: {
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };
    casks = [
      "balenaetcher"
      "burp-suite"
      "freecad"
      "jordanbaird-ice"
      "monero-wallet"
      "nextcloud"
      "obs"
      "obsidian"
      "onlyoffice"
      "orion"
      "prusaslicer"
      "raspberry-pi-imager"
      "vlc"
      "whisky"
      "whoozle-android-file-transfer"
    ];
  };
}
