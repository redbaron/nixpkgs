{ stdenv, fetchgit, cmake, boost, cocaine_core, curl, libnl, libswarm2, libtool, scatterOutputHook }:

stdenv.mkDerivation rec {
  version = "0.11.2.5";
  name = "cocaine_plugins-${version}";

  src = fetchgit {
    url = "https://github.com/cocaine/cocaine-plugins.git";
    rev = "2c663fb0400af05b0e2da94cc77d10a5942a4414"; #0.11.2.5 missing tag
    sha256 = "0857983fcf8a7924f18b246c73e0c2df705481fcd9b3c88e36b5b85148a184cb";
  };

  buildInputs = [ cmake cocaine_core curl libnl libswarm2 libtool scatterOutputHook ];

  cmakeFlags = [ "-DLIBNL_INCLUDE_DIRS=${libnl}/include/libnl3"
	"-DLIBNL_LIBRARY_DIRS=${libnl}/lib" ];

  enableParallelBuilding = true;

  outputs = [ "out" "bin" ];
  files_bin = [ "/lib/cocaine" ];

  preConfigure = ''
    export CMAKE_LIBRARY_PATH=$CMAKE_LIBRARY_PATH:${libnl}/lib
    sed -r -i 's,^(TARGET_LINK_LIBRARIES\(ipvs) nl\)$,\1 nl-3),' ipvs/libipvs-1.25/CMakeLists.txt 
    find -name "CMakeLists.txt" | xargs -- sed -r -i -e "s,(boost_[^-]+)-mt,\1,"
  '';
 
  meta = with stdenv.lib; {
    description = "Plugins for Cocaine PaaS cloud platform";
    homepage = https://github.com/cocaine/cocaine-core/wiki; 
    maintainers = [ maintainers.redbaron ];
    license = licenses.bsd3;
    platforms = platforms.linux;
  };
}
