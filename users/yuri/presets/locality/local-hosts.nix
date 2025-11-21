# home file for computers that i work on
{ config, pkgs, ... }:
{
  fonts.fontconfig.enable = true;
  imports = [
    ../../cli/just.nix
    ../../cli/lazygit.nix
    ../../cli/nix-search-tv.nix
    ../../applications/feishin.nix
    ../../applications/kitty.nix
    ../../applications/wakatime.nix
    ../../applications/zed.nix
  ];
  home.packages = with pkgs; [
    commitlint-rs
    devenv
    erdtree
    ffmpeg-full
    meslo-lgs-nf
    nerd-fonts.jetbrains-mono
    yubikey-manager
  ];
  sops.age.generateKey = false;

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."catboy-house" = {
      hostname = "46.4.241.139";
      user = "yuri";
      port = 29158;
      identityFile = "${config.home.homeDirectory}/.ssh/id_catboy-house";
    };
    matchBlocks."*.repo.borgbase.com" = {
      hostname = "%h";
      identityFile = "${config.home.homeDirectory}/.ssh/id_borgbase";
    };
    matchBlocks."mantis" = {
      hostname = "192.168.0.11";
      user = "yuri";
      port = 20615;
      identityFile = "${config.home.homeDirectory}/.ssh/id_mantis";
    };
    matchBlocks."github.com" = {
      user = "git";
      identityFile = "${config.home.homeDirectory}/.ssh/id_github";
    };
    matchBlocks."gitlab.com" = {
      user = "git";
      identityFile = "${config.home.homeDirectory}/.ssh/id_gitlab";
    };
    matchBlocks."gitlab.alt.coop" = {
      identityFile = "${config.home.homeDirectory}/.ssh/id_gitlab_alt_coop";
    };
    matchBlocks."ocelot" = {
      hostname = "192.168.0.10";
      user = "root";
      port = 20141;
      identityFile = "${config.home.homeDirectory}/.ssh/id_ocelot";
    };
    matchBlocks."otacon" = {
      hostname = "192.168.0.242";
      user = "yuri";
      port = 21896;
      identityFile = "${config.home.homeDirectory}/.ssh/id_otacon";
    };

    matchBlocks."*" = {
      identitiesOnly = true;
    };
  };
  programs.fish.shellAbbrs = {
    "catboy-house" = "ssh catboy-house -t bash";
    "mantis" = "ssh mantis -t fish";
  };
}
