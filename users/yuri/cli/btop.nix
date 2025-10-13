{ ... }:
let
  theme = builtins.readFile (
    builtins.fetchurl {
      url = "https://github.com/catppuccin/btop/blob/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_mocha.theme";
      sha256 = "0yy441kyqwlpgl3sdv1s4fm2cf72h5q3b6qvqqb4pylw5i0rdgl1";
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
