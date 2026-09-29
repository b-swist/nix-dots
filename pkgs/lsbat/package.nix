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
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "b-swist";
    repo = "lsbat";
    rev = "392f971fb82b43a1b89ad03cfb2cce370a3e2b65";
    hash = "sha256-s5gERT+yJPutktiS0CFqbaOsLOWZU+cE5VqWKNDLJC0=";
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
