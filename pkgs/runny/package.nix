{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "runny";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "b-swist";
    repo = finalAttrs.pname;
    tag = "v${finalAttrs.version}";
    hash = "sha256-kVSlrAk42uDzUYupVlT4tID5Pw0gW1gOqSd+HgL2Kl0=";
  };

  vendorHash = "sha256-E/lcFQFtfCBu9U16tiU9buxJERHEVLmfoXRNrIB6Nq4=";

  meta = {
    description = "Application launcher in your terminal";
    mainProgram = "runny";
    homepage = "https://github.com/b-swist/runny";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
