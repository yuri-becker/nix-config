set quiet

[private]
default:
  just --list

[doc("Rebuilds system")]
[macos]
rebuild action="switch":
    {{ if action == "switch" { "sudo " } else { "" } }}darwin-rebuild {{ action }} --flake .

[doc("Rebuilds system or home-manager configuration.")]
[linux]
rebuild action="switch":
    #!/usr/bin/env bash
    set -euxo pipefail
    osname=`awk -F= '$1=="NAME" { print $2 ;}' /etc/os-release`
    if [[ "$osname" == "NixOS" ]]; then
        {{ if action == "switch" { "sudo " } else { "" } }}nixos-rebuild {{ action }} --flake .
    else
        nix run home-manager/master -- {{ action }} --flake .
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

[doc("Updates the flake and rebuilds")]
update-and-switch:
  #!/usr/bin/env bash
  just update
  if [[ "$(git status -s | grep -F "flake.lock" | wc --lines)" -eq 0 ]]; then
    echo -e "\033[1;32mNo updates available.\033[0;m"
    exit
  fi

  just rebuild

  git add "flake.lock"
  if [[ "$(git status -s | grep -F -v 'M  flake.lock' | wc --lines)" -eq 0 ]]; then
    echo -e "\033[1;32mPress anything to commit and push…\033[0;m" && read -p ""
    git commit -m "Update flake"
    git push
  else
    echo -e "\033[1;33m⚠️ Changes outside of flake.lock detected - Not commiting"
  fi

alias u := update-and-switch

[doc("Re-encrypts the secrets files after the keys in .sops.yaml were changed.")]
sops-updatekeys:
  for file in $(find . -name '*secrets.yaml'); do nix-shell -p sops --run "sops updatekeys --yes $file"; done

[doc("Edit a secrets file.")]
sops file:
  nix-shell -p sops --run "sops {{ file }}"
