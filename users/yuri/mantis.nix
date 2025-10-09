{ ... }:
{
  imports = [
    ./presets/common.nix
    ./presets/os/linux.nix
    ./presets/locality/remote-hosts.nix
    ./applications/vesktop.nix
  ];
}
