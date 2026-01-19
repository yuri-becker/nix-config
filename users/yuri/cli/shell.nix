{
  config,
  lib,
  pkgs,
  ...
}:
{
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
    }
    // (
      if !config.localhost.enable then
        { }
      else
        {
          de = "devenv";
          deu = "devenv up";
          des = "devenv shell";
        }
    );
    functions = {
      otp = "${pkgs.yubikey-manager}/bin/ykman oath accounts code -s $argv | wl-copy";
    };
    shellInit = lib.mkIf pkgs.stdenv.isDarwin "fish_add_path /opt/homebrew/bin";
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
        CachyOS = " ";
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
