[private]
default:
  @just --list

[macos]
darwin:
    sudo darwin-rebuild switch --flake .

remotes tag='*':
    nix run .#colmena -- build --impure --on @{{ tag }}
    nix run .#colmena -- apply --impure --on @{{ tag }}

update:
  nix flake update

sops-updatekeys:
  for file in $(find . -name '*secrets.yaml'); do nix-shell -p sops --run "sops updatekeys --yes $file"; done

sops file:
  nix-shell -p sops --run "sops {{ file }}"
