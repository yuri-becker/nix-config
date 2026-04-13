{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  imports = [
    ./applications
    ./cli
    ./services
    ./options.nix
  ];
  config =
    let
      packages.common = with pkgs; [
        age
        fzf
        openssl
        rsync
        taplo
        wget
      ];
      packages.localhost = with pkgs; [
        config.localhost.font.system.package
        config.localhost.font.mono.package
        bruno
        commitlint-rs
        curtail
        devenv
        ffmpeg-full
        gnome-maps
        google-fonts
        ncdu
      ];
      packages.localhostLinux = with pkgs; [
        apostrophe
        cameractrls-gtk4
        dialect
        diebahn
        eyedropper
        forge-sparks
        gradia
        gthumb
        krita
        papers
        simple-scan
        textpieces
        uxplay
        wl-clipboard
      ];
      packages.personal = with pkgs; [ fladder ];
      packages.localhostDarwin = with pkgs; [
        cyberduck
        iina
        raycast
        shottr
        the-unarchiver
      ];
      packages.work = with pkgs; [
        figma-agent
        noto-fonts
      ];
      packages.gaming = with pkgs; [
        chiaki-ng
        gamescope
        heroic
        protontricks
        steam-rom-manager
      ];
      packages.gamingNixos = with pkgs; [
        # Packages need to be manually installed on non-nixos
        bottles
        proton-ge-bin
        steam
      ];
    in
    {
      localhost.font = {
        system = lib.mkDefault {
          name = "Aleo";
          package = pkgs.aleo-fonts;
        };
        mono = lib.mkDefault {
          name = "GeistMono Nerd Font";
          package = pkgs.nerd-fonts.geist-mono;
        };
      };

      # Home Manager
      programs.home-manager.enable = true;
      news.display = "silent";
      fonts.fontconfig.enable = lib.mkIf config.localhost.enable true;
      home.stateVersion = "25.05";
      home.username = "yuri";
      xdg.autostart.enable = (config.localhost.enable && pkgs.stdenv.isLinux);

      # SOPS
      sops.defaultSopsFormat = "yaml";
      sops.age.generateKey = !config.localhost.enable;
      sops.age.keyFile =
        if pkgs.stdenv.isDarwin then
          "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt"
        else
          "${config.home.homeDirectory}/.config/sops/age/keys.txt";

      # Packages and programs without config
      home.packages =
        packages.common
        ++ lib.optionals config.localhost.enable packages.localhost
        ++ lib.optionals (config.localhost.enable && pkgs.stdenv.isLinux) packages.localhostLinux
        ++ lib.optionals (config.localhost.enable && pkgs.stdenv.isDarwin) packages.localhostDarwin
        ++ lib.optionals (config.localhost.gaming.enable) packages.gaming
        ++ lib.optional (config.localhost.gaming.enable && specialArgs.type == "nixos") packages.gamingNixos
        ++ lib.optionals config.localhost.personal.enable packages.personal
        ++ lib.optionals config.localhost.work.enable packages.work
        ++ lib.optionals (
          config.localhost.personal.enable && (pkgs.stdenv.isx86_64 || pkgs.stdenv.isDarwin)
        ) [ pkgs.fastmail-desktop ]
        ++ lib.optionals (config.localhost.personal.enable && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
          pkgs.teamspeak6-client
        ];
    };

}
