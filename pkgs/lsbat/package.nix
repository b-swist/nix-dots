{
  lib,
  bash,
  fetchFromGitHub,
  gawk,
  makeWrapper,
  stdenv,
  util-linux,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "lsbat";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "b-swist";
    repo = "lsbat";
    tag = "1.0.1";
    hash = "sha256-eiafNZi58L3rMv3oq5WRkEm76I1KytbY3DXaQdFJTpM=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;
  dontConfigure = true;

  installFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    wrapProgram $out/bin/lsbat \
      --prefix PATH : ${
        lib.makeBinPath [
          bash
          gawk
          util-linux
        ]
      }
  '';

  meta = {
    description = "Display information about batteries";
    mainProgram = "lsbat";
    homepage = "https://github.com/b-swist/lsbat";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
  };
})
