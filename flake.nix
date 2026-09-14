{
  description = "Description for the project";

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
              libreoffice-qt-fresh
              texliveminimal
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
