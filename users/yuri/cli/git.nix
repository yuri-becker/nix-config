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
      user.name = "Yuri";
      user.email = "hi@yuri.li";
      init.defaultBranch = "main";
      push.autoSetupRemote = true;

      aliases = {
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
    signing = {
      signByDefault = true;
      format = "ssh";
      key = "${config.home.homeDirectory}/.ssh/id_github";
    };
  };
  programs.git.includes = lib.optional config.localhost.work.enable {
    condition = "gitdir:~/Projects/";
    contents = {
      user = {
        name = "Yuri Becker";
        email = "yuri@control.alt.coop";
        signingKey = "${config.home.homeDirectory}/.ssh/id_gitlab_alt_coop";
      };
    };
  };
  programs.diff-so-fancy = {
    enable = true;
    enableGitIntegration = true;
  };
  home.packages = with pkgs; [ gitflow ];
}
