{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && !pkgs.stdenv.isDarwin) {
    home.packages = with pkgs; [ beeper ];
    xdg.autostart.entries = [ "${pkgs.beeper}/share/applications/beepertexts.desktop" ];
  };
}
