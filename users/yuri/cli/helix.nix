{ pkgs, ... }:
{
  home.packages = with pkgs; [
    marksman
    nixd
    nixfmt-rfc-style
    yaml-language-server
  ];
  programs.helix = {
    enable = true;
    defaultEditor = true;
    themes.catppuccin_mocha_transparent = {
      inherits = "catppuccin_mocha";
      "ui.background" = { };
    };
    settings = {
      theme = "catppuccin_mocha_transparent";
      editor.rulers = [ 80 ];
      editor.line-number = "relative";
      editor.cursor-shape = {
        normal = "underline";
        insert = "bar";
        select = "block";
      };
      editor.indent-guides = {
        render = true;
        character = "▏";
      };
      keys.normal = {
        "Cmd-f" = ":format";
        "Cmd-S-ret" =
          ":run-shell-command kitten @ launch --type window --cwd current --copy-env hx %{buffer_name}";
        "Cmd-g" = ":run-shell-command kitten @ launch --type overlay --cwd current --copy-env lazygit";
        "Cmd-n" = "@:o <C-r>%<C-w>";
        "Cmd-e" = "@ b<down>";
        "Cmd-S-down" = [
          "extend_to_line_bounds"
          "delete_selection"
          "paste_after"
          "select_mode"
          "goto_line_start"
          "normal_mode"
        ];
        "Cmd-S-up" = [
          "extend_to_line_bounds"
          "delete_selection"
          "move_line_up"
          "paste_before"
          "flip_selections"
        ];
      };
    };
    languages = {
      language-server.nixd = {
        command = "${pkgs.nixd}/bin/nixd";
        options.home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.<name>.options.home-manager.users.type.getSubOptions []";
      };
      language-server.wakatime = {
        command = "wakatime-ls";
      };
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
          language-servers = [
            "nixd"
            "wakatime"
          ];
        }
        {
          name = "python";
          language-servers = [
            "ty"
            "wakatime"
          ];
        }
        {
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "wakatime"
          ];
        }
        {
          name = "markdown";
          language-servers = [
            "markdown"
            "wakatime"
          ];
        }
        {
          name = "yaml";
          language-servers = [
            "yaml-language-server"
            "wakatime"
          ];
        }
      ];
    };
  };
  programs.fish.functions.dev = ''
    if count $argv > /dev/null
      cd $argv
    end
    if type -q kitten
      kitten @ set-window-title "$(basename $(pwd))"
    end
    hx .
  '';
}
