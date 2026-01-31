{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) {
    programs.onlyoffice = {
      enable = true;
    };
  };
}
