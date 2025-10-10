{ ... }:
let
  theme = builtins.readFile (
    builtins.fetchurl {
      url = "https://github.com/catppuccin/btop/blob/f437574b600f1c6d932627050b15ff5153b58fa3/themes/catppuccin_mocha.theme";
      sha256 = "0x1bfpffcy6sqsv3j4lalsby57kwbaqda31fak3sckns4wc153f4";
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
