{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable { home.packages = with pkgs; [ feishin ]; };
}
