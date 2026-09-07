{
  pkgs,
  git-hooks,
  system,
}:
git-hooks.lib.${system}.run {
  src = ./.;
  hooks = {
    nixfmt.enable = true;
    elm-test.enable = false;
    elm-format.enable = true;
    prettier.enable = true;

    elm-test-rs = {
      enable = true;
      name = "elm-test-rs";
      description = "Run Elm tests with elm-test-rs";
      language = "system";
      files = "\\.elm$";
      pass_filenames = false;
      entry = "${pkgs.elmPackages.elm-test-rs}/bin/elm-test-rs";
    };

    ts-test = {
      enable = true;
      name = "ts-test";
      description = "Run vitest via npm run test:ts";
      language = "system";
      files = "\\.(js|jsx|ts|tsx)$";
      pass_filenames = false;
      entry =
        let
          wrapper = pkgs.writeShellApplication {
            name = "run-ts-test";
            runtimeInputs = [ pkgs.nodejs_26 ];
            text = ''
              npm run test:ts -- run
            '';
          };
        in
        "${wrapper}/bin/run-ts-test";
    };
  };
}
