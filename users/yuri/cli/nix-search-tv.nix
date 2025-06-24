{ pkgs, ... }: {
  home.packages = with pkgs; [ nix-search-tv ];
  programs.fish.shellAbbrs.ns =
    "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
}
