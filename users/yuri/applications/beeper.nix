{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux && pkgs.stdenv.isx86_64) {
    home.packages = with pkgs; [ beeper ];
    xdg.autostart.entries = [ "${pkgs.beeper}/share/applications/beepertexts.desktop" ];
  };
}
