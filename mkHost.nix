{
  nix-darwin,
  nixpkgs,
  home-manager,
  ...
}:
specialArgs:
{
  hostname,
  type ? "nixos",
  system ? "x86_64-linux",
  buildOnTarget ? true,
}:
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
      extraSpecialArgs = {
        inherit hostname;
      }
      // specialArgs;
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
  }
