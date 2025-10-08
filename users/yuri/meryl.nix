{ ... }:
{
  imports = [
    ./presets/common.nix
    ./presets/linux.nix
    ./presets/work.nix
    ./presets/local-hosts.nix
    ./toolchains/python.nix
  ];
}
