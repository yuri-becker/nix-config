{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = with pkgs; [ yubikey-manager ] ++ lib.optional stdenv.isLinux wl-clipboard;
    programs.fish.functions.otp =
      let
        copy = if pkgs.stdenv.isLinux then "${pkgs.wl-clipboard}/bin/wl-copy" else "pbcopy";
        ykman = lib.getExe pkgs.yubikey-manager;
      in
      "${ykman} oath accounts code -s $argv | ${copy}";
  };
}
