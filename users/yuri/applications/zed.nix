{ lib, pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixd
  ];
  programs.zed-editor = {
    enable = true;
    extensions = [
      "angular"
      "catppuccin"
      "catppuccin-icons"
      "docker-compose"
      "dockerfile"
      "env"
      "html"
      "java"
      "nix"
      "scss"
      "tokyo-night"
      "toml"
      "wakatime"
    ];
    extraPackages = with pkgs; [
      nil
      nixd
      package-version-server
    ];
    userSettings = {
      autosave.after_delay.milliseconds = 1000;
      base_keymap = "JetBrains";
      buffer_font_family = "JetBrainsMono Nerd Font";
      buffer_font_size = 22;
      cursor_shape = "bar";
      disable_ai = true;
      git.inline_blame.enabled = false;
      helix_mode = true;
      icon_theme = "Catppuccin Mocha";
      minimap.display_in = "active_editor";
      minimap.max_width_columns = 80;
      minimap.show = "auto";
      minimap.thumb = "always";
      prettier.allowed = true;
      project_panel.default_width = 300;
      soft_wrap = "editor_width";
      tab_bar.show = false;
      tab_size = 2;
      telemetry = {
        diagnostics = false;
        metrics = false;
      };
      title_bar = {
        show_branch_icon = true;
        show_sign_in = false;
      };
      terminal.shell.program = "${lib.getExe pkgs.fish}";
      theme = "Tokyo Night";
      ui_font_family = ".SystemUIFont";
      ui_font_size = 18.0;

      languages.Nix = {
        formatter.external = {
          command = "${lib.getExe pkgs.nixfmt-rfc-style}";
          arguments = [ "--strict" ];
        };
      };
    };
    userKeymaps = [
      {
        context = "Editor && mode == full";
        bindings = {
          "cmd-e" = "tab_switcher::Toggle";
          "cmd-`" = "terminal_panel::Toggle";
          "cmd+shift+'" = "workspace::ToggleZoom";
        };
      }
      {
        context = "Terminal";
        bindings = {
          "cmd-t" = "workspace::NewTerminal";
          "cmd-w" = "pane::CloseActiveItem";
        };
      }
    ];
  };
}
