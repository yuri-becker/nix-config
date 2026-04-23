{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = [ pkgs.apostrophe ];
    dconf.settings."org/gnome/gitlab/somas/Apostrophe" = {
      hemingway-mode = false;
      input-format = "gfm";
      preview-mode = "windowed";
      preview-security = "ask";
      toolbar-active = true;
    };
  };
}
