{
  description = "bootxnix - unprivileged Incus NixOS lab box (dwm, Rose Pine) for CTF/lab work";

  inputs = {
    # Pinned to the release that matches the linuxcontainers image:
    #   incus image list images: nixos  ->  nixos/26.05 (container, amd64)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # brightio/penelope is a single stdlib-only script with no flake of its
    # own; used only if the pinned nixpkgs has no `penelope` attribute.
    penelope = {
      url = "github:brightio/penelope";
      flake = false;
    };
  };

  outputs = { self, nixpkgs, zen-browser, penelope, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.bootxnix = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit zen-browser penelope; };
        modules = [ ./hosts/bootxnix.nix ];
      };
    };
}
