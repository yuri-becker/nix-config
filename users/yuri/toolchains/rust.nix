# Module for Rust Development
{ pkgs, ... }: {
  home.packages = with pkgs; [
    cargo
    cargo-shuttle
    cargo-watch
    clippy
    rustc
    rustfmt
    sea-orm-cli
    jetbrains.rust-rover
  ];

  programs.fish.shellAbbrs = {
    clippy = "cargo clippy --fix --allow-dirty --allow-staged";
  };
}
