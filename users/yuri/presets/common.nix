# Common home configuration for all hosts.
# Basically home-manager config and personal CLI essentials.
{ pkgs, ... }:
{
  # TODO: Might be nicer in usage to have one "default.nix" that imports darwin and remote-hosts by args

  imports = [
    ../cli/bat.nix
    ../cli/btop.nix
    ../cli/git.nix
    ../cli/helix.nix
    ../cli/lsd.nix
    ../cli/hyfetch.nix
    ../cli/shell.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.05";
  home.username = "yuri";
  home.packages = with pkgs; [
    age
    fzf
    gitflow
    tlrc
    openssl
    rsync
    taplo
    wget
  ];
  programs.jq.enable = true;
  services.tldr-update.enable = true;
  sops.defaultSopsFormat = "yaml";
}
