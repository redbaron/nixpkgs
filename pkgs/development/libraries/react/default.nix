{ stdenv, fetchgit, cmake, boost, scatterOutputHook }:

stdenv.mkDerivation rec {
  version = "2.3.1";
  name = "react-${version}";

  src = fetchgit {
    url = "https://github.com/reverbrain/react.git";
    rev = "refs/tags/v${version}";
    sha256 = "d6ea12986cbbd824f964d6f2fc159a2ec8599aa9863b2b45cf411da7c786aa62";
  };

  nativeBuildInputs = [ scatterOutputHook ];
  buildInputs = [ cmake boost ];
  outputs = [ "out" "bin" ];

  enableParallelBuilding = true;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=RelWithDebInfo" ];
 

  meta = with stdenv.lib; {
    description = "Realtime call tree for C++";
    homepage = https://github.com/reverbrain/react; 
    maintainers = [ maintainers.redbaron ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}
