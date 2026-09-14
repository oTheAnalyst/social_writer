{
  description = "flake for documents and resume and misc app I dont want installed on my base system";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux"];
      perSystem = {
        pkgs,
        system,
        ...
      }: {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        devShells = {
          default = pkgs.mkShell {
            packages = with pkgs; [
              libreoffice-qt-stable
              texliveSmall
            ];
          };
          social = pkgs.mkShell {
            packages = with pkgs; [
              whatsie
              element-desktop
            ];
          };
          full-shell = pkgs.mkShell {
            inputsFrom = with self.devShells.${system}; [default social];
          };
        };
      };
    };
}
