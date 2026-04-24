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
      create-ssh-key = ''
        ssh-keygen -t ed25519 -f  ~/.ssh/id_$argv -C "$(whoami)@$(hostname) id_$argv $(date)" -N ""
        ${pkgs.coreutils}/bin/cat ~/.ssh/id_$argv | wl-copy
        echo "✅ id_$argv.pub copied to clipboard!"
      '';
      which-package = ''
        readlink -f $(which $argv) | sed 's#^/nix/store/[[:alnum:]]\+-##'
      '';
    };
    shellInit = lib.mkIf pkgs.stdenv.isDarwin "fish_add_path /opt/homebrew/bin";
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableInteractive = true;
    settings = {
      cmake.symbol = " ";
      container.symbol = " ";
      deno.symbol = " ";
      directory.read_only = " 󰌾";
      git_branch.symbol = " ";
      git_commit.tag_symbol = "  ";
      hostname.ssh_symbol = " ";
      java.symbol = " ";
      nix_shell.symbol = "󱄅 ";
      nodejs.symbol = " ";
      os.disabled = false;
      os.symbols = {
        CachyOS = " ";
        Debian = " ";
        Fedora = " ";
        Macos = " ";
        NixOS = " ";
      };
      package.symbol = "󰏗 ";
      python.symbol = " ";
      typst.symbol = " ";
      rust.symbol = "󱘗 ";
    };
  };
  home.shell.enableFishIntegration = true;
}
