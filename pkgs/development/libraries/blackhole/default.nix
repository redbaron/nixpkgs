{ stdenv, fetchgit, cmake }:

stdenv.mkDerivation rec {
  version = "0.1.0";
  name = "blackhole-${version}";

  src = fetchgit {
    url = "https://github.com/3Hren/blackhole.git";
    rev = "refs/tags/v{$version}";
    sha256 = "cfbef50123734ffb9e94c31d5fc70e93a705d6b794de40a42adc50abaadb4d3c";
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