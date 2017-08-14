{ mkDerivation, base, hakyll, pandoc, skylighting, stdenv }:
mkDerivation {
  pname = "site-e";
  version = "0.1.0.0";
  src = ./.;
  isLibrary = false;
  isExecutable = true;
  executableHaskellDepends = [ base hakyll pandoc skylighting ];
  license = stdenv.lib.licenses.asl20;
}
