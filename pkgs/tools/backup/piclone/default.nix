{ autoconf
, automake
, autoreconfHook
, coreutils
# , dbus
# , dosfstools
# , e2fsprogs
, fetchFromGitHub
, glib
, gnome
, gnum4
, gtk3
, intltool
, m4
# , mount
, parted
, pkg-config
, stdenv
}:
stdenv.mkDerivation {
  name = "piclone";
  src = fetchFromGitHub {
    owner = "IvanMalison";
    repo = "piclone";
    rev = "047ac284dc9ec7e15bd4fcee590fe1ba95e157b3";
    sha256 = "sha256-0LmXKrRHPxC5XkJq0yeGdkTUJCbm+FKab3xmagQO9mc==";
  };

  preConfigure = ''
    ./autogen.sh
  '';

  nativeBuildInputs = [ autoconf automake autoreconfHook m4 intltool pkg-config ];

  buildInputs = [ coreutils parted gnome.zenity gnum4 glib m4 gtk3 ];
}
