{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.moonlight.enable {
    home.packages = with pkgs; [ moonlight-qt ];
  };
}
