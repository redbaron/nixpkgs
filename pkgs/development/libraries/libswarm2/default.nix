{ stdenv, fetchgit, cmake, boost, curl, libev, liburiparser, libxml2, scatterOutputHook }:

stdenv.mkDerivation rec {
  version = "0.6.2.0";
  name = "libswarm2-${version}";

  src = fetchgit {
    url = "https://github.com/reverbrain/swarm.git";
    rev = "589447e9a"; #master
    sha256 = "7684bd72005dde607bb851f24c7a3f7ca56e43a7d6281c8c588f4b3405b94295";
  };

  outputs = [ "out" "bin" ];

  nativeBuildInputs = [scatterOutputHook ];
  buildInputs = [ cmake boost curl libev liburiparser libxml2 ];

  meta = with stdenv.lib; {
    description = "high-perfomance library for web crawling";
    homepage = https://github.com/reverbrain/swarm;
    maintainers = [ maintainers.redbaron ];
    license = licenses.bsd3;
    platforms = platforms.all; 
  };  
}
