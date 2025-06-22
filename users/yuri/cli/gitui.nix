{ ... }:
let
  theme = builtins.readFile (builtins.fetchurl {
    url =
      "https://raw.githubusercontent.com/catppuccin/gitui/df2f59f847e047ff119a105afff49238311b2d36/themes/catppuccin-mocha.ron";
    sha256 = "a2e4a295fb288ee349eadfe88c28f04b68cdc9dbc673b00d13b1851793e4aa3e";
  });
in {
  programs.gitui = {
    enable = true;
    theme = theme;
  };
}
