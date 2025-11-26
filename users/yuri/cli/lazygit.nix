{ ... }:
{
  programs.lazygit = {
    enable = true;
    settings = {
      gui.theme = {
        activeBorderColor = [
          "#cba6f7"
          "bold"
        ];
        inactiveBorderColor = [ "#a6adc8" ];
        optionsTextColor = [ "#89b4fa" ];
        selectedLineBgColor = [ "#313244" ];
        cherryPickedCommitBgColor = [ "#45475a" ];
        cherryPickedCommitFgColor = [ "#cba6f7" ];
        unstagedChangesColor = [ "#f38ba8" ];
        defaultFgColor = [ "#cdd6f4" ];
        searchingActiveBorderColor = [ "#f9e2af" ];
      };
      gui.authorColors = {
        "*" = "#f9e2af";
        "Yuri Becker" = "#b4befe";
        "Yuri" = "#b4befe";
      };
      gui.screenMode = "half";
      git.overrideGpg = true;
    };
  };

  programs.fish.shellAbbrs.lg = "lazygit";
}
