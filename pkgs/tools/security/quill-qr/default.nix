{ bash
, coreutils
, fetchFromGitHub
, gzip
, jq
, lib
, makeWrapper
, qrencode
, stdenv
, util-linux
}:

stdenv.mkDerivation rec {
  pname = "quill-qr";
  version = "e66726bda5177975bca11507214236d841eed32b";

  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "quill-qr";
    rev = "${version}";
    sha256 = "1kdsq6csmxfvs2wy31bc9r92l5pkmzlzkyqrangvrf4pbk3sk0r6";
  };

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    mkdir -p $out/bin
    cp -a quill-qr.sh $out/bin/quill-qr.sh
  '';

  wrapperPath = with lib; makeBinPath [
    qrencode
    coreutils
    jq
    gzip
    util-linux
  ];

  fixupPhase = ''
    patchShebangs $out/bin

    wrapProgram $out/bin/quill-qr.sh --prefix PATH : "${wrapperPath}"
  '';

  meta = {
    description = "Print QR codes for use with https://p5deo-6aaaa-aaaab-aaaxq-cai.raw.ic0.app/ (https://github.com/ninegua/ic-qr-scanner) ";
    homepage = "https://github.com/IvanMalison/quill-qr";
    maintainers = with lib.maintainers; [ imalison ];
    platforms = with lib.platforms; linux;
  };
}
