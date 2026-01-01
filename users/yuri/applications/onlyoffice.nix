{ config, lib, ... }:
{
  config = lib.mkIf config.localhost.enable {
    programs.onlyoffice = {
      enable = true;
    };
  };
}
