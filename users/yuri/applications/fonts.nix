{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.localhost.enable {
    home.packages = with pkgs; [
      font-adobe-utopia-type1
      font-mutt-misc
      google-fonts
      newcomputermodern
      nerd-fonts.jetbrains-mono
    ];
  };
}
