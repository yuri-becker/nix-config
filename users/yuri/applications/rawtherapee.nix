{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.personal.enable {
    home.packages = lib.mkIf pkgs.stdenv.isLinux [ pkgs.rawtherapee ];
  };
}
