{ pkgs, ... }:
{
  programs.fish = {
    functions.nix-search = "${pkgs.nix-search-tv}/bin/nix-search-tv print | fzf --preview '${pkgs.nix-search-tv}/bin/nix-search-tv preview {}' --scheme history";
    shellAbbrs.ns = "nix-search";
  };
}
