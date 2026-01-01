{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = with lib; {
    localhost.enable = mkEnableOption "that this host is meant to be locally interacted with";
    localhost.personal.enable = mkEnableOption "toolchain for personal workloads";
    localhost.work.enable = mkEnableOption "toolchain for wage-labour-related workloads";
  };

  config = {
    # Home Manager
    programs.home-manager.enable = true;
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

    # Packages and one-liner programs
    home.packages =
      with pkgs;
      [
        age
        bruno
        fzf
        openssl
        rsync
        taplo
        wget
      ]
      ++ lib.optionals config.localhost.enable [
        commitlint-rs
        devenv
        erdtree
        ffmpeg-full
        meslo-lgs-nf
        nerd-fonts.jetbrains-mono
      ]
      ++ lib.optionals pkgs.stdenv.isLinux [
        cameractrls-gtk4
        epiphany
        gthumb
        wl-clipboard
      ]
      ++ lib.optionals pkgs.stdenv.isDarwin [
        cyberduck
        iina
        raycast
        shottr
        the-unarchiver
      ]
      ++ lib.optionals config.localhost.personal.enable [ fastmail-desktop ]
      ++ lib.optionals (config.localhost.personal.enable && pkgs.stdenv.isLinux) [ teamspeak6-client ];
  };

  imports = [
    ./applications
    ./cli
  ];
}
