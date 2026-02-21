{
  description = "My nix config ༼ つ ▀̿_▀̿ ༽つ";

  nixConfig.warn-dirty = false;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    colmena = {
      url = "github:zhaofengli/colmena";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wakatime-ls = {
      url = "github:mrnossiom/wakatime-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-silicon.url = "github:nix-community/nixos-apple-silicon/release-25.11";
  };

  outputs =
    inputs:
    let
      entrypoints = {
        inherit (inputs)
          nix-darwin
          nixpkgs
          home-manager
          colmena
          ;
      };
      specialArgs = {
        inherit (inputs)
          self
          home-manager
          sops-nix
          wakatime-ls
          apple-silicon
          ;
      };
      lib = import ./lib.nix { inherit (inputs) nixpkgs; };
      mkHost = lib.mkHost entrypoints specialArgs;
      mkHive = lib.mkHive entrypoints specialArgs;
    in
    lib.deepMerge [
      (mkHost { hostname = "meryl"; })
      (mkHost {
        hostname = "solid";
        type = "home-manager";
      })
      (mkHost {
        hostname = "liquid";
        type = "darwin";
        system = "aarch64-darwin";
      })
      (mkHost {
        hostname = "liquidus";
        type = "nixos";
        system = "aarch64-linux";
      })
      (mkHost {
        hostname = "otacon";
        type = "image";
        system = "aarch64-linux";
      })
      (mkHive [
        (mkHost {
          hostname = "mantis";
          type = "colmena";
        })
        (mkHost {
          hostname = "otacon";
          buildOnTarget = false;
          type = "colmena";
        })
      ])
    ];
}
