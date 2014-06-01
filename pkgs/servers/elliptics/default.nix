{ stdenv, fetchgit, cmake, pythonPackages, boost, eblob, cocaine_core, cocaine_framework_native, react, blackhole, libtool }:

stdenv.mkDerivation rec {
  version = "2.25.4.11";
  name = "elliptics-${version}";

  src = fetchgit {
    url = "https://github.com/reverbrain/elliptics.git";
    rev = "refs/tags/v${version}";
    sha256 = "39ad3faf72a707f030aa2936f812031d8d0345d69940c5c861d2cdf0de27ebb6";
  };
  
  #outputs = [ "out" "bin"  ];
  #files_bin = [ "/bin/*" "/lib/*.so*" "/lib/cocaine" "/lib/python*" ];
  #files_python = [ "/lib/python*" ];

  cmakeFlags = [ "-DCMAKE_BUILD_TYPE=RelWithDebInfo" ];
  
  buildInputs = [ cmake pythonPackages.python boost eblob cocaine_core cocaine_framework_native react blackhole libtool pythonPackages.wrapPython ];
  
  preFixup = ''wrapPythonPrograms'';

  enableParallelBuilding = true;
}
