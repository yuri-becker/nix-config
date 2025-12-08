{ ... }:
{
  imports = [
    ./presets/common.nix
    ./presets/hardware/audio.nix
    ./presets/locality/local-hosts.nix
    ./presets/os/linux.nix
    ./presets/usecase/work.nix
    ./applications/gnome
  ];
  xdg.autostart.enable = true;
}
