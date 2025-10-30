[private]
default:
  @just --list

[macos]
rebuild:
    sudo darwin-rebuild switch --flake .

[linux]
rebuild:
    if `awk -F= '$1=="NAME" { print $2 ;}' /etc/os-release` == "NixOS"
    {
        sudo nixos-rebuild switch --flake .
    } else {
        nix run home-manager/master -- switch --flake .
    }

alias r := rebuild

[positional-arguments]
colmena node:
    nix run .#colmena -- build --impure --on {{ node }}
    nix run .#colmena -- apply --impure --on {{ node }}
alias c := colmena

[positional-arguments]
build-sd node:
    nix build .#nixosConfigurations.{{ node }}.config.system.build.sdImage

update:
  nix flake update
alias u := update

sops-updatekeys:
  for file in $(find . -name '*secrets.yaml'); do nix-shell -p sops --run "sops updatekeys --yes $file"; done

sops file:
  nix-shell -p sops --run "sops {{ file }}"
