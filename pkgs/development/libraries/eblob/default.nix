{ stdenv, fetchgit, cmake, python, boost, react, scatterOutputHook }:

stdenv.mkDerivation rec {
  version = "0.21.38";
  name = "eblob-${version}";

  src = fetchgit {
    url = "https://github.com/reverbrain/eblob.git";
    rev = "refs/tags/v${version}";
    sha256 = "e78aad173c1d2a7f5e7410b48adfc102042b6904eb6bf5c44d3ef7567a2106c1";
  };

  nativeBuildInputs = [scatterOutputHook ];
  buildInputs = [ cmake python boost react ];
  outputs = [ "out" "bin" ];

  postPatch = "sed -i -e /RPATH/d CMakeLists.txt";

  enableParallelBuilding = true;

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=RelWithDebInfo" ];
 
  meta = with stdenv.lib; {
    description = "BLOB data container";
    homepage = http://doc.reverbrain.com/eblob:eblob; 
    maintainers = [ maintainers.redbaron ];
    license = licenses.lgpl3;
    platforms = platforms.all;
  };
}
