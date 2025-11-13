{ pkgs, ... }:
{
  programs.zed-editor = {
    enable = true;
    extensions = [
      "angular"
      "ansible"
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
      telemetry.diagnostics = false;
      telemetry.metrics = false;
      terminal.shell.program = "${pkgs.fish}/bin/fish";
      theme = "Tokyo Night";
      ui_font_family = ".SystemUIFont";
      ui_font_size = 18.0;
    };
  };
}
