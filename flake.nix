{
  description = "My nix config ༼ つ ▀̿_▀̿ ༽つ";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, home-manager, sops-nix }: {
    darwinConfigurations."liquid" = nix-darwin.lib.darwinSystem {
      specialArgs = { inherit self home-manager sops-nix; };
      modules = [ ./hosts/liquid ];
    };
  };
}
