{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.gaming.enable { home.packages = [ pkgs.pcsx2 ]; };
}
