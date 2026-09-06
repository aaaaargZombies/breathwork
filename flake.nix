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
        let
          inherit (elm2nix.lib.elm2nix pkgs)
            generateRegistryDat
            prepareElmHomeScript
            installPatchesScript
            ;

          elmLock = ./elm.lock;
          registryDat = generateRegistryDat { inherit elmLock; };
        in
        {
          default = pkgs.buildNpmPackage {
            name = "Site";

            nativeBuildInputs = [
              elm.packages.${system}.default
              elm2nix.packages.${system}.default
              pkgs.nodejs_26
            ];
            src = self;
            npmDeps = pkgs.importNpmLock { npmRoot = self; };
            npmConfigHook = pkgs.importNpmLock.npmConfigHook;

            preBuild = ''
              ${prepareElmHomeScript { inherit elmLock registryDat; }}
              ${installPatchesScript elm2nix.lib.elmSafeVirtualDom.elmHtml}
              # NOTE: hack to fix 0.19.1 -> 0.19.2
              mv .elm/0.19.1 .elm/0.19.2
            '';

            installPhase = ''
              mkdir -p "$out/share"
              cp -R dist/. "$out/share"/
            '';
          };
        }
      );

      formatter = forEachSupportedSystem ({ pkgs, ... }: pkgs.nixfmt);
    };
}
