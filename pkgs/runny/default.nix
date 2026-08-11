{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule (finalAttrs: {
  pname = "runny";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "b-swist";
    repo = finalAttrs.pname;
    rev = "v${finalAttrs.version}";
    hash = "sha256-Jo4nhBZ28i8RH08MQFcp5mBW+C40K37GQGK12mCxZms=";
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
