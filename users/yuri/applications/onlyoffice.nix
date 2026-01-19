{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    programs.onlyoffice = {
      enable = true;
    };
  };
}
