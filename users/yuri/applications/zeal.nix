{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = with pkgs; [ zeal ];

    xdg.configFile."Zeal/Zeal.conf".text = lib.generators.toINI { } {
      General = {
        check_for_update = false;
        hide_on_close = false;
        minimize_to_systray = false;
        show_systray_icon = false;
        start_minimized = false;
      };
      content = {
        appearance = "@Variant(\0\0\0\x7f\0\0\0\x12\x43ontentAppearance\0\0\0\0\0)";
        default_fixed_font_size = 16;
        default_font_family = "serif";
        default_font_size = 16;
        external_link_policy = "@Variant(\0\0\0\x7f\0\0\0\x13\x45xternalLinkPolicy\0\0\0\0\x2)";
        fixed_font_family = config.localhost.font.mono.name;
        highlight_on_navigate = true;
        minimum_font_size = 0;
        sans_serif_font_family = "DejaVu Sans";
        serif_font_family = config.localhost.font.system.name;
        smooth_scrolling = true;
      };
      docsets.path = "${config.home.homeDirectory}/.local/share/Zeal/Zeal/docsets";
      global_shortcuts.show = "";
      proxy = {
        authenticate = false;
        host = "";
        ignore_ssl_errors = false;
        password = "";
        port = 0;
        type = 1;
        username = "";
      };
      search.fuzzy_search_enabled = true;
    };
  };
}
