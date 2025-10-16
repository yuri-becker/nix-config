{ config, pkgs, ... }:
{
  imports = [
    ../../toolchains/web-dev.nix
    ../../toolchains/python.nix
    ../../toolchains/tex.nix
    ../../applications/geary-work.nix
    ../../applications/librewolf.nix
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
    mattermost-desktop
    signal-desktop-bin
  ];

  xdg.autostart.entries = [
    "${pkgs.mattermost-desktop}/share/applications/Mattermost.desktop"
    "${pkgs.signal-desktop-bin}/share/applications/signal.desktop"
  ];
}
