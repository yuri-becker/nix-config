{ config, lib, ... }:
{
  config = lib.mkIf config.localhost.personal.enable { programs.yt-dlp.enable = true; };
}
