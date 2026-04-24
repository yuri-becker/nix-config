{ config, lib, ... }:
{
  config.programs.foliate = lib.mkIf config.localhost.enable {
    enable = true;
  };
}
