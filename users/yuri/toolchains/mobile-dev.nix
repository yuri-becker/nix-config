# Module for iOS and Android App Development
{ pkgs, ... }: {
  home.packages = with pkgs; [ fastlane bundletool ];
  programs.gradle.enable = true;
  programs.rbenv.enable = true;
}
