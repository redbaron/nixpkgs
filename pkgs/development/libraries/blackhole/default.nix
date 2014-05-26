{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "blackhole-${version}";

  src = fetchgit {
    url = "https://github.com/3Hren/blackhole.git";
    rev = "refs/tags/v{$version}";
    sha256 = "222ac73d279f6e8b55ce6b393aef676e699a73df7df977a7534ce505034cd4dd";
  };
  
  cmakeFlags = [
  	     "-DBLACKHOLE_DEBUG=OFF"
  	     "-DENABLE_TESTING=OFF"
	     "-DENABLE_EXAMPLES=OFF"
	     "-DENABLE_BENCHMARKING=OFF" ];

  buildInputs = [ cmake ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Blackhole Logger";
    homepage = http://3hren.github.io/blackhole/; 
    maintainers = [ maintainers.redbaron ];
    license = licenses.bsd2;
    platforms = platforms.all;
  };
}
