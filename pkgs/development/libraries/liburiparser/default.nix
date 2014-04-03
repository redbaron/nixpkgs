{ stdenv, fetchgit, scatterOutputHook, autoreconfHook }:

stdenv.mkDerivation rec {
  version = "0.8.0";
  name = "liburiparser-${version}";

  src = fetchgit {
    url = "git://git.code.sf.net/p/uriparser/git";
    rev = "refs/tags/uriparser-${version}";
    sha256 = "0357ba23b444af5a798f00b045c1270adc8813957be6877398ef94ceb8fcfcc8";
  };

  configureFlags = [ "--disable-test" "--disable-doc" ];

  outputs = [ "out" "bin" ];

  nativeBuildInputs = [ scatterOutputHook autoreconfHook ];

  meta = with stdenv.lib; {
    description = "URI parsing library compliant with RFC 3986";
    homepage = http://http://uriparser.sourceforge.net;
    maintainers = [ maintainers.redbaron ];
    license = licenses.bsd3;
    platforms = platforms.all;
  };
}
