{
  description = "My nix config ༼ つ ▀̿_▀̿ ༽つ";

  nixConfig.warn-dirty = false;

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
    colmena.inputs.nixpkgs.follows = "nixpkgs";
    wakatime-ls.url = "github:mrnossiom/wakatime-ls";
    wakatime-ls.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      sops-nix,
      colmena,
      wakatime-ls,
    }:
    {
      darwinConfigurations."liquid" = nix-darwin.lib.darwinSystem {
        specialArgs = {
          inherit
            self
            home-manager
            sops-nix
            wakatime-ls
            ;
        };
        modules = [ ./hosts/liquid ];
      };
      nixosConfigurations."meryl" = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit
            self
            home-manager
            sops-nix
            wakatime-ls
            ;
        };
        modules = [ ./hosts/meryl ];
      };
      homeConfigurations."yuri" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          sops-nix.homeManagerModule
          ./users/yuri/solid.nix
        ];
        extraSpecialArgs = {
          inherit wakatime-ls;
          hostname = "solid";
        };
      };
      colmenaHive = colmena.lib.makeHive {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };
          specialArgs = { inherit home-manager sops-nix; };
        };
        defaults = {
          time.timeZone = "Europe/Berlin";
          i18n.defaultLocale = "en_US.UTF-8";
          nix.settings = {
            experimental-features = [
              "nix-command"
              "flakes"
            ];
          };
          deployment = {
            buildOnTarget = true;
            targetUser = null;
          };
        };
        mantis = import ./hosts/mantis;
      };
      apps = colmena.apps;
    };
}
