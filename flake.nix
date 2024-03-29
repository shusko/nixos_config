{
  description = "System flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {

      seanbox_4080super = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/seanbox_4080super

          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { }; # Pass extra args to home.nix with this set
            home-manager.users = {
              sean = import ./users/sean/home.nix;

              # Add additional users here
            };
          }

        ];
      };

      # Add additional host machine configs here

    };
  };
}
