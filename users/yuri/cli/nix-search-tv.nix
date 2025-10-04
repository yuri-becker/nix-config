{ pkgs, ... }:
{
  programs.fish = {
    functions.nix-search = "${pkgs.nix-search-tv} print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    shellAbbrs.ns = "nix-search";
  };
}
