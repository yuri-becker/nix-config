{ pkgs, ... }: {
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
    };
    languages = {
      language-server.nixd = { command = "${pkgs.nixd}/bin/nixd"; };
      language = [{
        name = "nix";
        auto-format = true;
        formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        language-servers = [ "nixd" ];
      }];
    };
  };
}
