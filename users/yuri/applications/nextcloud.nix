{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.personal.enable && pkgs.stdenv.isLinux) {
    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
