{ stdenv, fetchurl, fetchhg, go, sqlite}:

assert stdenv.isLinux && (stdenv.isi686 || stdenv.isx86_64 || stdenv.isArm);

stdenv.mkDerivation rec {
  name = "storebrowse-20130318212204";

  src = fetchurl {
    url = "http://viric.name/cgi-bin/storebrowse/tarball/storebrowse-775928f68e53.tar.gz?uuid=775928f68e53";
    name = "${name}.tar.gz";
    sha256 = "1yb8qbw95d9561s10k12a6lwv3my8h52arsbfcpizx74dwfsv7in";
  };

  # This source has license BSD
  srcGoSqlite = fetchhg {
    url = "https://code.google.com/p/gosqlite/";
    tag = "5baefb109e18";
    sha256 = "0mqfnx06jj15cs8pq9msny2z18x99hgk6mchnaxpg343nzdiz4zk";
  };

  buildPhase = ''
    PATH=${go}/bin:$PATH
    mkdir $TMPDIR/go
    export GOPATH=$TMPDIR/go

    ${stdenv.lib.optionalString (stdenv.system == "armv5tel-linux") "export GOARM=5"}

    GOSQLITE=$GOPATH/src/code.google.com/p/gosqlite
    mkdir -p $GOSQLITE
    cp -R $srcGoSqlite/* $GOSQLITE/
    export CGO_CFLAGS=-I${sqlite}/include
    export CGO_LDFLAGS=-L${sqlite}/lib
    go build -ldflags "-r ${sqlite}/lib" -o storebrowse
  '';

  installPhase = ''
    ensureDir $out/bin
    cp storebrowse $out/bin
  '';

  meta = {
    homepage = http://viric.name/cgi-bin/storebrowse;
    license = "AGPLv3+";
  };
}
