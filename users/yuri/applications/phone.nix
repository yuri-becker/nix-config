{ pkgs, ... }:
{
  home.packages = with pkgs; [ linphonePackages.linphone-desktop ];
  home.file.".linphone-sounds".source = "${pkgs.linphonePackages.liblinphone}/share/sounds/linphone";
}
