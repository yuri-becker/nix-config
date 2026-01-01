{ config, ... }:
{
  imports = [
    ../../toolchains/java.nix
    ../../toolchains/web-dev.nix
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
}
