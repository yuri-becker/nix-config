{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.nix-options.gc-older-than =
    with lib;
    mkOption {
      type = types.str;
      default = "7d";
    };

  config.nix = {
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
}
