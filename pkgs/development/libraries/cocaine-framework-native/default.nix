{ stdenv, fetchgit, cmake, boost, cocaine_core, libev, libmsgpack,  scatterOutputHook }:

stdenv.mkDerivation rec {
  name = "cocaine_framework_native-0.11.1.0";

  src = fetchgit {
    url = "https://github.com/cocaine/cocaine-framework-native.git";
    rev = "66283e454a81b2b87c4f348b1adcc70d29ce0877";
    sha256 = "6c639d02aefd5cf5e0c991e2377fcb364dfe05406d1e07ff0add0bbc2541012c";
  };

  buildInputs = [ cmake boost cocaine_core ];
  propagatedBuildInputs = [ cocaine_core ];

  nativeBuildInputs = [ scatterOutputHook ];

  enableParallelBuilding = true;

  outputs = [ "out" "bin" ];

  preConfigure = ''
    sed -r -i -e "s,(boost_[^-]+)-mt,\1," CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "Cocaine Native Framework";
    homepage = https://github.com/cocaine/cocaine-core/wiki; 
    maintainers = [ maintainers.redbaron ];
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
