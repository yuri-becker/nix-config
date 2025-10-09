{ ... }:
{
  imports = [
    ./presets/common.nix
    ./presets/hardware/office.nix
    ./presets/locality/local-hosts.nix
    ./presets/os/linux.nix
    ./presets/usecase/work.nix
    ./applications/aonsoku.nix
    ./applications/gnome
  ];
}
