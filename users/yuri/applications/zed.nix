{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    # home.packages = with pkgs; [
      # nil
      # nixd
      # tinymist
    # ];
    programs.zed-editor = {
      enable = true;
      extensions = [
        "angular"
        "ansible"
        "catppuccin"
        "catppuccin-icons"
        "django"
        "docker-compose"
        "dockerfile"
        "env"
        "git-firefly"
        "html"
        "justfile"
        "nix"
        "scss"
        "tokyo-night"
        "toml"
        "typst"
        "wakatime"
      ];
      extraPackages = with pkgs; [
        just-lsp
        nil
        nixd
        package-version-server
        tinymist
      ];
      userSettings = {
        active_pane_modifiers.inactive_opacity = 0.7;
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
        project_panel = {
          button = true;
          default_width = 300;
          hide_root = true;
        };
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

        # Nix
        languages.Nix = {
          formatter.external = {
            command = "${lib.getExe pkgs.nixfmt}";
            arguments = [ "--strict" ];
          };
        };
        lsp.nil = {
          settings = {
            nix.flake.autoArchive = true;
          };
        };
        lsp.tinymist = {
          settings = {
            "exportPdf" = "onSave";
            "outputPath" = "$root/$name";
          };
        };

        file_types.Ansible = [
          "**.ansible.yml"
          "**.ansible.yaml"
          "**/defaults/*.yml"
          "**/defaults/*.yaml"
          "**/meta/*.yml"
          "**/meta/*.yaml"
          "**/tasks/*.yml"
          "**/tasks/*.yaml"
          "**/handlers/*.yml"
          "**/handlers/*.yaml"
          "**/group_vars/*.yml"
          "**/group_vars/*.yaml"
          "**/playbooks/*.yaml"
          "**/playbooks/*.yml"
          "**playbook*.yaml"
          "**playbook*.yml"
        ];
      };
      userKeymaps =
        let
          panelCommons = panel: {
            "cmd-'" = "terminal_panel::ToggleFocus";
            "cmd-/" = "project_panel::ToggleFocus";
            "cmd-w" =
              if panel == "project_panel" then "workspace::CloseActiveDock" else "pane::CloseActiveItem";
            "f1" = "projects::OpenRecent";
            "f2" = "workspace::Open";
            "cmd-e" =
              if panel == "editor" then
                [
                  "action::Sequence"
                  [
                    "${panel}::ToggleFocus"
                    "tab_switcher::Toggle"
                  ]
                ]
              else
                "tab_switcher::Toggle";
          };
        in
        [
          {
            context = "Editor && mode == full";
            bindings = panelCommons "editor" // {
              "cmd-[" = "pane::GoBack";
              "cmd-]" = "pane::GoForward";
              "cmd-shift-up" = "editor::MoveLineUp";
              "cmd-shift-down" = "editor::MoveLineDown";
            };
          }
          {
            context = "TabSwitcher";
            bindings = {
              "cmd-e" = "menu::SelectNext";
              "cmd-up" = "menu::SelectPrevious";
              "cmd-down" = "menu::SelectNext";
              "cmd-w" = "tab_switcher::CloseSelectedItem";
            };
          }
          {
            context = "ProjectPanel";
            bindings = panelCommons "project_panel" // { };
          }
          {
            context = "Terminal";
            bindings = panelCommons "terminal_panel" // {
              "cmd-t" = "workspace::NewTerminal";
              "cmd-[" = "pane::ActivatePreviousItem";
              "cmd-]" = "pane::ActivateNextItem";
            };
          }
        ];
    };
  };
}
