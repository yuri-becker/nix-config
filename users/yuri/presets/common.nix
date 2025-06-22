# Common home configuration for all hosts.
# Basically home-manager config and personal CLI essentials.
{ config, pkgs, ... }: {
  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  home.username = "yuri";
  home.packages = with pkgs; [
    bat
    fastfetch
    fzf
    gitflow
    lsd
    nix-search-tv
    nixd
    nixfmt-classic
    openssl
    rsync
    taplo
    tlrc
    wget
  ];
  home.sessionVariables = { EDITOR = "hx"; };
  programs.jq.enable = true;
  services.tldr-update = {
    enable = true;
    package = pkgs.tlrc;
  };

  sops = {
    defaultSopsFormat = "yaml";
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.generateKey = false;
  };

  imports = [
    ../cli/btop.nix
    ../cli/git.nix
    ../cli/gitui.nix
    ../cli/helix.nix
    ../cli/hyfetch.nix
    ../cli/shell.nix
  ];
}
