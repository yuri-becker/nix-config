{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = with lib; {
    docker.enable = mkEnableOption "docker";
    localhost.enable = mkEnableOption "that this host is meant to be locally interacted with";
    localhost.office.enable = mkEnableOption "that this host uses the hardware i use in the office";
    nix-options.gc-older-than = mkOption {
      type = types.str;
      default = "7d";
    };
  };
  imports = [ ./office-hardware.nix ];
  config = {
    environment.systemPackages = with pkgs; [ ] ++ lib.optionals config.localhost.enable [ vial ];
    services.udev = lib.mkIf config.localhost.enable {
      packages = with pkgs; [ qmk-udev-rules ];
      # Epomaker Alice 66 and Keychron Q11
      extraRules = ''
        KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="36b0", ATTRS{idProduct}=="300a", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
        KERNEL=="hidraw*", SUBSYSTEMS=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="01e0", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
      '';
    };
    virtualisation.docker = lib.mkIf config.docker.enable {
      enable = true;
      rootless.enable = true;
      rootless.setSocketVariable = true;
    };
    programs.nix-ld = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) { enable = true; };

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
  };
}
