{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Yuri";
        email = "hi@yuri.li";
        signingkey = "${config.home.homeDirectory}/.ssh/id_github";
      };
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      signing = {
        signByDefault = true;
        format = "ssh";
      };

      alias = {
        a = "add";
        A = "add .";
        b = "branch";
        c = "commit";
        d = "diff";
        fl = "flow";
        flr = "flow release";
        flrs = "flow release start";
        flrf = "flow release finish";
        flf = "flow feature";
        flfs = "flow feature start";
        flff = "flow feature finish";
        fall = "fetch --all --prune";
        g = "grep";
        j = "jump";
        l = "list";
        m = "merge";
        o = "checkout";
        p = "pull";
        pu = "push";
        pufl = "push --force-with-lease";
        s = "status";
        w = "whatchanged";
        list = "log --oneline --decorate --all";
        gr = "graph";
        chb = "checkout -b";
        ignore = "update-index --assume-unchanged";
        unignore = "update-index --no-assume-unchanged";
        ignored = ''!git ls-files -v | grep "^[[:lower:]]'';
        wip = ''!git commit -m " WIP " --no-verify && git push'';
      };
    };

    includes =
      let
        conditions.remote = host: "hasconfig:remote.*.url:git@${host}:*/**";
        contents.altCoop = keyname: {
          user = {
            name = "Yuri Becker";
            email = "yuri@control.alt.coop";
            signingKey = "${config.home.homeDirectory}/.ssh/${keyname}";
          };
        };
      in
      [
        {
          condition = conditions.remote "git.alt.coop";
          contents = contents.altCoop "id_git_alt_coop";
        }
        {
          condition = conditions.remote "gitlab.alt.coop";
          contents = contents.altCoop "id_gitlab_alt_coop";
        }
      ];
  };
  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };
  home.packages = with pkgs; [
    gitflow
  ];
}
