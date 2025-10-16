{ ... }:
let
  theme = builtins.readFile (
    builtins.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/btop/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_mocha.theme";
      sha256 = "0i263xwkkv8zgr71w13dnq6cv10bkiya7b06yqgjqa6skfmnjx2c";
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
