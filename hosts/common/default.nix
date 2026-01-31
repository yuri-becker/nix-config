{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  options = with lib; {
    docker.enable = mkEnableOption "docker";
    yubikey-pam.enable = mkEnableOption "pam module for YubiKey";
    localhost.enable = mkEnableOption "that this host is meant to be locally interacted with";
    localhost.office.enable = mkEnableOption "that this host uses the hardware i use in the office";
    nix-options.gc-older-than = mkOption {
      type = types.str;
      default = "7d";
    };
  };
  imports = [
    ./pam.nix
    ./linux.nix
  ];
  config = {
    nix = {
      settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      settings.trusted-users = [
        "root"
        "@wheel"
      ];
      optimise.automatic = true;
      extraOptions = ''
        extra-substituters = https://devenv.cachix.org
        extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
      '';
      gc = lib.mergeAttrs {
        automatic = true;
        options = "--delete-older-than ${config.nix-options.gc-older-than}";
      } (if pkgs.stdenv.isDarwin then { interval.Hour = 4; } else { dates = "daily"; });
    };
    nixpkgs.config.allowUnfree = true;
    nixpkgs.hostPlatform.system = specialArgs.system;

    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      # See https://man.archlinux.org/man/locale.5
      LC_ADDRESS = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_TIME = "en_DK.UTF-8";
    };
  };
}
