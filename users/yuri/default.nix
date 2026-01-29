{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  options = with lib; {
    localhost.enable = mkEnableOption "that this host is meant to be locally interacted with";
    localhost.personal.enable = mkEnableOption "toolchain for personal workloads";
    localhost.work.enable = mkEnableOption "toolchain for wage-labour-related workloads";
    localhost.gnome.enable = mkEnableOption "gnome configuration";
    localhost.gaming.enable = mkEnableOption "games!!";
  };

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
        bruno
        commitlint-rs
        devenv
        ffmpeg-full
        meslo-lgs-nf
        ncdu
        nerd-fonts.jetbrains-mono
      ];
      packages.localhostLinux = with pkgs; [
        cameractrls-gtk4
        epiphany
        gthumb
        pwvucontrol
        uxplay
        wl-clipboard
      ];
      packages.personal = with pkgs; [ ];
      packages.personalLinux = with pkgs; [
        fladder
        krita
      ];
      packages.localhostDarwin = with pkgs; [
        cyberduck
        iina
        raycast
        shottr
        the-unarchiver
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
        ++ lib.optionals (config.localhost.personal.enable && pkgs.stdenv.isLinux) packages.personalLinux
        ++ lib.optionals (
          config.localhost.personal.enable && (pkgs.stdenv.isx86_64 || pkgs.stdenv.isDarwin)
        ) [ pkgs.fastmail-desktop ]
        ++ lib.optionals (config.localhost.personal.enable && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) [
          pkgs.teamspeak6-client
        ];
    };

  imports = [
    ./applications
    ./cli
    ./services
  ];
}
