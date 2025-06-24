{ pkgs, ... }: {
  programs.lsd = {
    enable = true;
    enableFishIntegration = false; # Personally, don't like how its done with abbrs instead of aliases.
  };
  programs.fish.functions.ls = "${pkgs.lsd}/bin/lsd $argv";
}
