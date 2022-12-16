{ lib, stdenv, makeWrapper, dpkg, fetchurl,
  glib, glib-networking, wrapGAppsHook,
  autoPatchelfHook, libsoup, dmidecode }:
let
  version = "2.1.21-2";
  rpath = stdenv.lib.makeLibraryPath [

  ] + ":${stdenv.cc.cc.lib}/lib64";

  src = 
	if stdenv.hostPlatform.system == "x86_64-linux" then
	  fetchurl {
		urls = [ "https://app.drivestrike.com/static/apt/pool/main/d/drivestrike/drivestrike_${version}_amd64.deb" ];
		sha256 = "059m3x387kjz4j3c0sbz3wdbh2dn0dxq1rq8vhdbf5m3bswc3i4d";
	  }
	else
	  throw "Drivestrike is not supported on ${stdenv.hostPlatform.system}";
in stdenv.mkDerivation {
  pname = "drivestrike";
  inherit version;

  system = "x86_64-linux";

  inherit src;

  nativeBuildInputs = [ autoPatchelfHook wrapGAppsHook glib glib-networking makeWrapper ];

  buildInputs = [ dpkg libsoup dmidecode ];

  dontUnpack = true;

  installPhase = ''
	mkdir -p $out
	dpkg -x $src $out
	cp -av $out/usr/* $out
	rm -rf $out/usr

	chmod -R g-w $out
  '';

  postFixup = ''
	wrapProgram $out/bin/drivestrike \
	--prefix PATH ":" "${lib.makeBinPath [ dmidecode ]}"
  '';
}
