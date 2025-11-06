{ config, pkgs, ... }:
{
  imports = [
    ../../toolchains/web-dev.nix
    ../../toolchains/java.nix
    ../../toolchains/python.nix
    ../../toolchains/tex.nix
    ../../applications/evolution-work.nix
    ../../applications/librewolf.nix
    ../../applications/onlyoffice.nix
    ../../applications/phone.nix
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
  ];

  xdg.autostart.entries = [
    "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop"
    "${pkgs.beeper}/share/applications/beepertexts.desktop"
    "${pkgs.linphone}/share/applications/linphone.desktop"
  ];

}
