{ pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ./../../../packages/moosync.nix { })
  ];
}
