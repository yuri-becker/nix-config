# Module for Rust Development
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # cargo-shuttle
    # cargo-watch
    # rustup
    # sea-orm-cli
  ];

  programs.fish.shellAbbrs = {
    clippy = "cargo clippy --fix --allow-dirty --allow-staged";
  };
}
