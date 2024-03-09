# My NixOS Config

A simple NixOS flake setup tracked by git.

## Build

To build a system, first `cd` into this repo at the root level where the `flake.nix` is. Hosts should be documented in the hosts directory. Specify a host to build with a 'sharp' and run the following.

```zsh
# Building seanbox_4080super system as example

sudo nixos-rebuild switch --flake $(pwd)#seanbox_4080super
```

## Creating a new User

To make a new user, create a new nix module under `./users/my_new_user` with entry point `default.nix`. Your user be managed by [home-manager](https://nixos.wiki/wiki/Home_Manager). Add home-manager as a Nix Module into your host config and import your user module into home-manager users. Follow the existing code as a guide in `flake.nix`.

## Creating a new Host

To create a new host, first [install NixOS](https://nixos.org/download) on the new machine.

Once the initial `/etc/nixos/` has been generated, create a new directory in this repo under `hosts` and move the auto generated nix config files into it. Change the `configuration.nix` file to `default.nix`. A file named `default.nix` indicates an entrypoint into a nix module.
```zsh
mkdir -p ./hosts/my-new-host
sudo mv /etc/nixos/hardware-configuration.nix ./hosts/my-new-host/hardware-configuration.nix
sudo mv /etc/nixos/configuration.nix ./hosts/my-new-host/default.nix
sudo chown -R $(id -un):$(id -gn) ./hosts/my-new-host
```

Remove the default location of your system config. From this point on, rebuilding the system will always require specifying a host from this repo.
```zsh
sudo rmdir /etc/nixos
```

Now you need to add the new host as a module in the `flake.nix`. Follow along with what's already in the file. Your new host should look something like this...
```nix
  #...

  outputs = { self, nixpkgs, home-manager }: {
    nixosConfigurations = {

      seanbox_4080super = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          # ...
        ];
      };

      my_new_host = nixpkgs.lib.nixosSystem {
        system = "<YOUR SYSTEM ARCH HERE>";
        modules = [
          ./hosts/my_new_host

          # Additional modules such as home-manager here
          # If you're adding a user, import from a module under ./users/
        ];
      };

      # Add additional host machine configs here

    };
  };
```

Building with a flake requires files to be added in `git`. Don't commit changes yet.
```zsh
git add flake.nix ./hosts/my-new-host
```

Now you can rebuild the system. You can make whatever changes you need to produce the proper state for your system. After updating any of your nix config files, you will need to `git add` the changes before rebuilding. Once your system state output is correct, `git commit` the changes to secure the state. With git, if something goes wrong, you can always checkout a previous system config and restore a previous state.
```zsh
sudo nixos-rebuild switch --flake .#my_new_host

# Update system packages and config as needed, git add, rebuild, repeat...

git commit


# Use git checkout/revert to rebuild any previous state you've committed
```
