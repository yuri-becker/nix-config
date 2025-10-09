[private]
default:
  @just --list

[macos]
rebuild:
    sudo darwin-rebuild switch --flake .

[linux]
rebuild:
    sudo nixos-rebuild switch --flake .

alias r := rebuild

colmena tag='*':
    nix run .#colmena -- build --impure --on @{{ tag }}
    nix run .#colmena -- apply --impure --on @{{ tag }}
alias c := colmena

update:
  nix flake update
alias u := update

sops-updatekeys:
  for file in $(find . -name '*secrets.yaml'); do nix-shell -p sops --run "sops updatekeys --yes $file"; done

sops file:
  nix-shell -p sops --run "sops {{ file }}"
