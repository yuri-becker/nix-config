{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    services.flatpak = {
      enable = lib.mkDefault true;
      packages = [ "org.onlyoffice.desktopeditors" ];
    };
  };
}
