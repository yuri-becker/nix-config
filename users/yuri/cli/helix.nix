{ pkgs, ... }:
let
  modifier = if pkgs.stdenv.isDarwin then "Cmd" else "Cmd";
in
{
  home.packages = with pkgs; [
    deno
    marksman
    nixdoc
    nixfmt-rfc-style
    taplo
    vscode-css-languageserver
    vscode-json-languageserver
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
        "${modifier}-f" = ":format";
        "${modifier}-S-ret" =
          ":run-shell-command kitten @ launch --type window --cwd current --copy-env hx %{buffer_name}";
        "${modifier}-e" = "@ b<down>";
        "${modifier}-S-down" = [
          "extend_to_line_bounds"
          "delete_selection"
          "paste_after"
          "select_mode"
          "goto_line_start"
          "normal_mode"
        ];
        "${modifier}-S-up" = [
          "extend_to_line_bounds"
          "delete_selection"
          "move_line_up"
          "paste_before"
          "flip_selections"
        ];
      };

      keys.normal.space = {
        "'" = "no_op";
        "F" = "no_op";
        ":" = ":write-all";
        "g" = [
          ":write-all"
          ":new"
          ":insert-output lazygit"
          ":buffer-close!"
          ":redraw"
          ":reload-all"
        ];
        "t" = [
          ":hsplit-new"
          ":insert-output fish"
        ];
        "G" = "no_op";
        "${modifier}-del" = [
          ":run-shell-command trash %"
          ":buffer-close"
        ];
        "n" = "@:o <C-r>%<C-w>";
      };
    };
    languages = {
      language-server = {
        nixd = {
          command = "${pkgs.nixd}/bin/nixd";
          config.nix.options.home-manager.expr =
            "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.<name>.options.home-manager.users.type.getSubOptions []";
        };
      };
      language = [
        {
          name = "json";
          language-servers = [
            "vscode-json-language-server"
            "wakatime"
          ];
          formatter.command = "${pkgs.deno}/bin/deno";
          formatter.args = [
            "fmt"
            "-"
            "--ext"
            "json"
          ];
        }
        {
          name = "markdown";
          formatter.command = "${pkgs.deno}/bin/deno";
          formatter.args = [
            "fmt"
            "-"
            "--ext"
            "md"
          ];
          language-servers = [
            "markdown"
            "wakatime"
          ];
        }
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
          name = "rust";
          language-servers = [
            "rust-analyzer"
            "wakatime"
          ];
        }
        {
          name = "toml";
          formatter.command = "${pkgs.taplo}/bin/taplo";
          formatter.args = [
            "format"
            "-"
          ];
          auto-format = true;
          language-servers = [
            "taplo"
            "wakatime"
          ];
        }
        {
          name = "yaml";
          language-servers = [
            "yaml-language-server"
            "wakatime"
          ];
          formatter.command = "${pkgs.prettier}/bin/prettier";
          formatter.args = [
            "--parser"
            "yaml"
          ];
        }
      ];
    };
  };
  programs.fish.functions.hx-grammar-rebuild = ''
    hx -g fetch
    nix shell nixpkgs#gcc --command hx -g build
  '';
}
