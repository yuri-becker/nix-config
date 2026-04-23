{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    home.packages = [ pkgs.tangram ];

    xdg.autostart.entries = [ "${pkgs.tangram}/share/applications/re.sonny.Tangram.desktop" ];

  };
}
