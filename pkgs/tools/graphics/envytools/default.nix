{ lib
, fetchFromGitHub
, stdenv
, cmake
, pkg-config
, libxml2
, flex
, bison
, libpciaccess
, libdrm
, libseccomp
, libX11
, libXext
, python3
, libvdpau
}:

stdenv.mkDerivation {
  pname = "envytools";
  version = "unstable-2022-04-30";

  src = fetchFromGitHub {
    owner = "envytools";
    repo = "envytools";
    rev = "e11d670a70ae0455261ead53cdd09c321974cc64";
    hash = "sha256-orESr6didV7TjbQu2KfBwtKcLpBN/OfIj2shU8XpoPQ";
  };

  patches = [ ./fix_nvrm_object_path.diff ];

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    libxml2
    flex
    bison
    libpciaccess
    libdrm
    libseccomp
    libX11
    libXext
    python3
    python3.pkgs.cython
    libvdpau
  ];

  meta = with lib; {
    homepage = "https://github.com/envytools/envytools";
    description = "Tools for people envious of nvidia's blob driver";
    maintainers = with maintainers; [ Benjamin-L ];
    license = licenses.mit;
    platforms = platforms.linux;
  };
}
