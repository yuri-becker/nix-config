{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [ fractal ];
  };
}
