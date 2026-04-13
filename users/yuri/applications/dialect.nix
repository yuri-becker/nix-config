{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf (config.localhost.enable && pkgs.stdenv.isLinux) {
    home.packages = with pkgs; [ dialect ];

    dconf.settings = {
      "app/drey/Dialect".show-pronunciation = true;
      "app/drey/Dialect/translators".active = "deepl";
      "app/drey/Dialect/tts".active = "";
    };
  };
}
