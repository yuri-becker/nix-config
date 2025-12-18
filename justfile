[private]
default:
  @just --list

[doc("Rebuilds system")]
[macos]
rebuild:
    sudo darwin-rebuild switch --flake .

[doc("Rebuilds system or home-manager configuration.")]
[linux]
rebuild:
    #!/usr/bin/env bash
    set -euxo pipefail
    osname=`awk -F= '$1=="NAME" { print $2 ;}' /etc/os-release`
    if [[ "$osname" == "NixOS" ]]; then
        sudo nixos-rebuild switch --flake .
    else
        nix run home-manager/master -- switch --flake .
    fi

alias r := rebuild

[doc("Builds and deployes a remote target.")]
[positional-arguments]
colmena node:
    nix run .#colmena -- build --impure --on {{ node }}
    nix run .#colmena -- apply --impure --on {{ node }}
alias c := colmena

[doc("Builds an image for flashing to an SD card.")]
[positional-arguments]
build-sd node:
    nix build .#nixosConfigurations.{{ node }}.config.system.build.sdImage

[doc("Updates the flake (does not update the system - rebuild to do that)")]
update:
  nix flake update
alias u := update

[doc("Re-encrypts the secrets files after the keys in .sops.yaml were changed.")]
sops-updatekeys:
  for file in $(find . -name '*secrets.yaml'); do nix-shell -p sops --run "sops updatekeys --yes $file"; done

[doc("Edit a secrets file.")]
sops file:
  nix-shell -p sops --run "sops {{ file }}"
