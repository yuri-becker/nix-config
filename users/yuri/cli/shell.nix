{ pkgs, ... }: {
  programs.fish = {
    enable = true;
    interactiveShellInit = "set fish_greeting";
    plugins = with pkgs.fishPlugins; [
      {
        name = "autopair";
        inherit (autopair) src;
      }
      {
        name = "fzf";
        inherit (fzf) src;
      }
    ];
    functions.cat = "${pkgs.bat}/bin/bat --plain --pager never $argv";
    functions.ls = "${pkgs.lsd}/bin/lsd $argv";
    shellAbbrs = {
      h = "history";
      l = "ls -lFh";
      la = "ls -lAFh";
      ll = "ls -l";
      cp = "cp -i";
      mv = "mv -i";
      rm = "rm -i";
      rimraf = "rm -rf";
      t = "tail -f";
      ns =
        "nix-search-tv print | fzf --preview 'nix-search-tv preview {}' --scheme history";
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableInteractive = true;
    settings = {
      cmake.symbol = " ";
      directory.read_only = " 󰌾";
      git_branch.symbol = " ";
      git_commit.tag_symbol = "  ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      nodejs.symbol = " ";
      os.disabled = false;
      os.symbols = {
        Debian = " ";
        Macos = " ";
        NixOS = " ";
      };
      package.symbol = "󰏗 ";
      python.symbol = " ";
      rust.symbol = "󱘗 ";
    };
  };
  home.shell.enableFishIntegration = true;
}
