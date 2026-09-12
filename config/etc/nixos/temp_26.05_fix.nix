# https://github.com/nixos/nixpkgs/issues/522307
{ ... }: {
  nixpkgs.overlays = [
    (final: prev: {
      # Переопределяем pipx внутри структуры pythonPackages
      pythonPackagesExtensions = prev.pythonPackagesExtensions ++ [
        (pythonFinal: pythonPrev: {
          pipx = pythonPrev.pipx.overridePythonAttrs (old: {
            doCheck = false;
          });
        })
      ];
    })
  ];
}
