{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.gnome.enable {
    programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [ { package = tophat; } ];
    dconf.settings = {
      "org/gnome/desktop/interface" = {
        lock-show-date = true;
        clock-show-weekday = true;
      };
      "org/gnome/shell/extensions/tophat" = {
        cpu-display = "numeric";
        fs-display = "chart";
        mem-display = "numeric";
        mount-to-monitor = "/";
        network-usage-unit = "bytes";
        position-in-panel = "left";
        show-disk = true;
        show-fs = false;
        show-net = false;
      };
    };
  };
}
