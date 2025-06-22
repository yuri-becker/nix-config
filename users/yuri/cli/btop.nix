{ ... }:
let
  theme = builtins.readFile (builtins.fetchurl {
    url =
      "https://github.com/catppuccin/btop/blob/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_mocha.theme";
    sha256 = "0ca0a7xrmz42dprr1krppy0yvg3apyck0sihmy8appcp1m1j0l4s";
  });
in {
  programs.btop = {
    enable = true;
    themes."Catppuccin-Mocha" = theme;
    settings = {
      color_theme = "Catppuccin-Mocha";
      theme_background = false;
    };
  };
}
