{ pkgs, ... }:
let
  theme = builtins.readFile (
    builtins.fetchurl {
      url = "https://github.com/catppuccin/btop/blob/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_mocha.theme";
      sha256 = # No idea why i get different SHA256s between Mac and Linux
        if pkgs.stdenv.isDarwin then
          "0yy441kyqwlpgl3sdv1s4fm2cf72h5q3b6qvqqb4pylw5i0rdgl1"
        else
          "13x4ar3l4pr03kcplyvrw641civfii4ypz901y0apwyjxd9ikh1m";
    }
  );
in
{
  programs.btop = {
    enable = true;
    themes."Catppuccin-Mocha" = theme;
    settings = {
      color_theme = "Catppuccin-Mocha";
      theme_background = false;
    };
  };
}
