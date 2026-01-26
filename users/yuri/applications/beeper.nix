{
  config,
  lib,
  pkgs,
  specialArgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && specialArgs.type == "nixos") {
    home.packages = with pkgs; [ beeper ];
    xdg.autostart.entries = [ "${pkgs.beeper}/share/applications/beepertexts.desktop" ];
  };
}
