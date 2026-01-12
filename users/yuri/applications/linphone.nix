{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.work.enable {
    home.packages = with pkgs; [ linphonePackages.linphone-desktop ];
    home.file.".linphone-sounds".source = "${pkgs.linphonePackages.liblinphone}/share/sounds/linphone";
    xdg.autostart.entries = [ "${pkgs.linphone}/share/applications/linphone.desktop" ];
  };
}
