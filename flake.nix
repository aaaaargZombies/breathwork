{
  description = "Development environment for a breathwork app";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    elm.url = "github:aaaaargZombies/elm-flake";
    elm2nix.url = "github:dwayne/elm2nix";
  };

  outputs =
    {
      self,
      elm,
      elm2nix,
      ...
    }@inputs:
    let
      inherit (inputs.nixpkgs) lib;

      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forEachSupportedSystem =
        f:
        lib.genAttrs supportedSystems (
          system:
          f {
            inherit system;
            pkgs = import inputs.nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
          }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs, system }:
        {
          default = pkgs.mkShellNoCC {
            packages = with pkgs; [
              self.formatter.${system}
              elm.packages.${system}.default
              elm2nix.packages.${system}.default
              pkgs.nodejs_26
            ];
          };
        }
      );

      packages = forEachSupportedSystem (
        { pkgs, system }:
        {
          default = pkgs.buildNpmPackage {
            name = "Site";

            nativeBuildInputs = [
              elm.packages.${system}.default
              elm2nix.packages.${system}.default
              pkgs.nodejs_26
            ];

            src = self;

            npmDeps = pkgs.importNpmLock {
              npmRoot = self;
            };

            npmConfigHook = pkgs.importNpmLock.npmConfigHook;

            # TODO: add the prepare elm home and patch packages section to this phase
            # - https://github.com/dwayne/elm2nix/blob/master/nix/build-elm-application.nix
            preBuild = ''
              echo "🐠 THIS IS THE PREBUILDPHASE 🐠"
              ls $ELM_HOME
            '';

            installPhase = ''
              which elm
              mkdir -p "$out/share"
              cp -R dist/. "$out/share"/
            '';
          };
        }
      );

      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
