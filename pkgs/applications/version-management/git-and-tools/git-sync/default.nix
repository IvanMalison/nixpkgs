{ lib, stdenv, fetchFromGitHub, coreutils, git, gnugrep, gnused, makeWrapper, inotify-tools }:

stdenv.mkDerivation rec {
  pname = "git-sync";
  version = "unstable-2021-07-14";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "git-sync";
    rev = "211facfdd910f424ef11bfe900d68a28065e1f59";
    sha256 = "sha256-kiwpWnrW9DP+IrH130Zp2SS7g9AumFseXe9q+BzbYss=";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a git-* $out/bin/
  '';

  wrapperPath = with lib; makeBinPath [
    inotify-tools
    coreutils
    git
    gnugrep
    gnused
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrap_path="${wrapperPath}":$out/bin

    wrapProgram $out/bin/git-sync \
      --prefix PATH : $wrap_path

    wrapProgram $out/bin/git-sync-on-inotify \
      --prefix PATH : $wrap_path
  '';

  meta = {
    description = "A script to automatically synchronize a git repository";
    homepage = "https://github.com/simonthum/git-sync";
    maintainers = with lib.maintainers; [ imalison ];
    license = lib.licenses.cc0;
    platforms = with lib.platforms; unix;
  };
}
