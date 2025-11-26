{ config, pkgs, ... }:
{
  imports = [
    ../../toolchains/java.nix
    ../../toolchains/web-dev.nix
    ../../toolchains/tex.nix
    ../../applications/librewolf.nix
    ../../applications/onlyoffice.nix
  ];

  programs.git.includes = [
    {
      condition = "gitdir:~/Projects/";
      contents = {
        user = {
          name = "Yuri Becker";
          email = "yuri@control.alt.coop";
        };
        signing.key = "${config.home.homeDirectory}/.ssh/id_gitlab_alt_coop";
      };
    }
  ];
  programs.ssh.matchBlocks."gitlab.alt.coop" = {
    identityFile = "${config.home.homeDirectory}/.ssh/id_gitlab_alt_coop";
  };

  home.packages = with pkgs; [
    beeper
    mattermost-desktop
    linphonePackages.linphone-desktop
  ];

  home.file.".linphone-sounds".source = "${pkgs.linphonePackages.liblinphone}/share/sounds/linphone";

  xdg.autostart.entries = [
    "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop"
    "${pkgs.beeper}/share/applications/beepertexts.desktop"
    "${pkgs.linphone}/share/applications/linphone.desktop"
  ];

}
