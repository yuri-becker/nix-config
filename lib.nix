{ nixpkgs }:
let
  deepMerge = with nixpkgs.lib; listOfAttrSets: foldl' recursiveUpdate { } listOfAttrSets;
in
{
  inherit deepMerge;
  mkHost =
    { nix-darwin, home-manager, ... }:
    extraSpecialArgs:
    {
      hostname,
      type ? "nixos",
      system ? "x86_64-linux",
      buildOnTarget ? true,
    }:
    let
      specialArgs = extraSpecialArgs // {
        inherit system hostname type;
      };
    in
    if type == "darwin" then
      {
        darwinConfigurations."${hostname}" = nix-darwin.lib.darwinSystem {
          inherit specialArgs;
          modules = [
            ./hosts/common
            ./hosts/${hostname}
          ];
        };
      }
    else if type == "image" then
      {
        nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
          inherit specialArgs;
          inherit system;
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            ./hosts/common
            ./hosts/${hostname}
            { sdImage.compressImage = false; }
          ];
        };
      }
    else if type == "home-manager" then
      {
        homeConfigurations."yuri" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
          modules = [
            specialArgs.sops-nix.homeManagerModule
            ./users/yuri
            {
              home.homeDirectory = "/home/yuri";
              targets.genericLinux.gpu.enable = true;
            }
            ./hosts/${hostname}
          ];
          extraSpecialArgs = specialArgs;
        };

      }
    else if type == "colmena" then
      {
        ${hostname} = {
          imports = [
            ./hosts/common
            ./hosts/${hostname}
          ];
          deployment = {
            inherit buildOnTarget;
            targetHost = hostname;
          };
        };
        meta.nodeSpecialArgs.${hostname} = specialArgs;
      }
    else
      {
        # assume NixOS
        nixosConfigurations."${hostname}" = nixpkgs.lib.nixosSystem {
          inherit specialArgs system;
          modules = [
            ./hosts/common
            ./hosts/${hostname}
          ];
        };
      };

  mkHive =
    { colmena, ... }:
    specialArgs: hosts: {
      colmenaHive = colmena.lib.makeHive (
        deepMerge (
          [
            {
              meta = {
                inherit specialArgs;
                nixpkgs = import nixpkgs { system = "x86_64-linux"; };
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
                deployment.targetUser = null;
              };
            }
          ]
          ++ hosts
        )
      );
      apps = colmena.apps;
    };
}
