# Common file for Mac systems
{ config, pkgs, ... }:
{
  programs.fish = {
    shellAbbrs.rebuild = "sudo darwin-rebuild switch --flake .";
    shellInit = "fish_add_path /opt/homebrew/bin";
  };
  home.packages = with pkgs; [
    cyberduck
    raycast
    shottr
    the-unarchiver
  ];
  programs.ssh.matchBlocks."*" = {
    addKeysToAgent = "yes";
    extraOptions = {
      UseKeychain = "yes";
    };
  };
  sops.age.keyFile = "${config.home.homeDirectory}/Library/Application Support/sops/age/keys.txt";
}
