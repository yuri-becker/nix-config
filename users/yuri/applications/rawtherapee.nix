{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.personal.enable { home.packages = [ pkgs.rawtherapee ]; };
}
