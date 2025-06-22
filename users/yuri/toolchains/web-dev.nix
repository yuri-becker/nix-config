# Module for Web Application Development
{ pkgs, ... }: {
  home.packages = with pkgs; [
    deno
    electron-chromedriver
    fnm
    hoppscotch
    yarn-berry
  ];

  # Untouched Chromium and Firefox for Application Testing
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;
  };
  programs.firefox.enable = true;
}
