{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    programs.onlyoffice = {
      enable = true;
      package = if pkgs.stdenv.isx86_64 then pkgs.onlyoffice-desktopeditors else null;
    };
  };
}
