{ config, lib, ... }:
{
  config = lib.mkIf config.podman.enable {
    virtualisation.containers.enable = true;
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      autoPrune = {
        enable = true;
        dates = "weekly";
      };
    };
  };
}
