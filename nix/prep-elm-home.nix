{
  writeShellScriptBin,
  elm2nixLib,
  elmLock,
  patches,
}:

let
  inherit (elm2nixLib) generateRegistryDat prepareElmHomeScript installPatchesScript;
  registryDat = generateRegistryDat { inherit elmLock; };
in
writeShellScriptBin "prep-elm-home" ''
  rm -rf .elm elm-stuff
  ${prepareElmHomeScript { inherit elmLock registryDat; }}
  ${installPatchesScript patches}
''
