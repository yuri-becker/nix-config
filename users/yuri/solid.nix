{ ... }:
{
  imports = [
    ./presets/common.nix
    ./presets/locality/local-hosts.nix
    ./presets/os/linux.nix
  ];
  home.homeDirectory = "/home/yuri";
  programs.kitty.package = null;
}
