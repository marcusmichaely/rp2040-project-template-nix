{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
    rust-overlay.url = "github:oxalica/rust-overlay";
  };

  outputs = { self, rust-overlay, nixpkgs }:
    let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        inherit overlays;
      };
    in
    {
      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [
          (rust-bin.stable.latest.minimal.override {
            targets = [ "thumbv6m-none-eabi" ];
            extensions = [ "rust-src" "cargo" "rustc" ];
          })
          rust-analyzer
          flip-link
          probe-run
          elf2uf2-rs
          rustfmt
          pkg-config
          udev.dev
        ];
      };
    };
}
