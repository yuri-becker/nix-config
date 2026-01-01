{
  config,
  pkgs,
  lib,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = with pkgs; [
      yubikey-manager
      wl-clipboard
    ];
    programs.fish.functions.otp = "${lib.getExe pkgs.yubikey-manager} oath accounts code -s $argv | ${pkgs.wl-clipboard}/bin/wl-copy";
  };
}
