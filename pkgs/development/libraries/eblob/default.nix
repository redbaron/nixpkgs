{ stdenv, fetchgit, cmake, python, boost, react, scatterOutputHook }:

stdenv.mkDerivation rec {
  version = "0.21.38";
  name = "eblob-${version}";

  src = fetchgit {
    url = "https://github.com/reverbrain/eblob.git";
    rev = "refs/tags/v${version}";
    sha256 = "ee49bd4bbb0fd83aca7e1c1d22bde9d02b7cb27fde7ee554d205ba45530d91ea";
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
