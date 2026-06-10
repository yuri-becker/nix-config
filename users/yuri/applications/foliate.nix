{
  config,
  lib,
  pkgs,
  ...
}:
{
  config.programs.foliate = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    enable = true;
  };
}
