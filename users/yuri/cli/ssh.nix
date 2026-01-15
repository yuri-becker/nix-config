{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        "catboy-house" = {
          hostname = "46.4.241.139";
          user = "yuri";
          port = 29158;
          identityFile = "${config.home.homeDirectory}/.ssh/id_catboy-house";
        };
        "*.repo.borgbase.com" = {
          hostname = "%h";
          identityFile = "${config.home.homeDirectory}/.ssh/id_borgbase";
        };
        "mantis" = {
          hostname = "192.168.0.11";
          user = "yuri";
          port = 20615;
          identityFile = "${config.home.homeDirectory}/.ssh/id_mantis";
        };
        "github.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/id_github";
        };
        "gitlab.com" = {
          user = "git";
          identityFile = "${config.home.homeDirectory}/.ssh/id_gitlab";
        };
        "gitlab.alt.coop" = {
          identityFile = "${config.home.homeDirectory}/.ssh/id_gitlab_alt_coop";
        };
        "git.alt.coop" = {
          identityFile = "${config.home.homeDirectory}/.ssh/id_git_alt_coop";
        };
        "ocelot" = {
          hostname = "192.168.0.10";
          user = "root";
          port = 20141;
          identityFile = "${config.home.homeDirectory}/.ssh/id_ocelot";
        };
        "otacon" = {
          hostname = "192.168.0.242";
          user = "yuri";
          port = 21896;
          identityFile = "${config.home.homeDirectory}/.ssh/id_otacon";
        };
        "hamilton" = {
          hostname = "hamilton.alt.coop";
          user = "yuri";
          identityFile = "${config.home.homeDirectory}/.ssh/id_hamilton";
        };
        "wagner" = {
          hostname = "wagner.alt.coop";
          user = "yuri";
          identityFile = "${config.home.homeDirectory}/.ssh/id_wagner";
        };
        "*" = {
          identitiesOnly = true;
          addKeysToAgent = lib.mkIf pkgs.stdenv.isDarwin "yes";
          extraOptions = {
            UseKeychain = lib.mkIf pkgs.stdenv.isDarwin "yes";
          };
        };
      };
    };
    programs.fish.shellAbbrs = {
      "catboy-house" = "ssh catboy-house -t bash";
      "mantis" = "ssh mantis -t fish";
    };
  };
}
