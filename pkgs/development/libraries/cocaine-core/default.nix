{ stdenv, fetchgit, cmake, boost, libev, openssl, libtool, libmsgpack, libuuid, libarchive, binutils, libcgroup, scatterOutputHook }:

stdenv.mkDerivation rec {
  version = "0.11.2.0";
  name = "cocaine_core-${version}";

  src = fetchgit {
    url = "https://github.com/cocaine/cocaine-core.git";
    rev = "refs/tags/${version}";
    sha256 = "06912c2b5add4786e92d0f38d9ecfe184d03e98c2cea5fcbf370f244846596bf";
  };

  buildInputs = [cmake boost libev openssl libtool libmsgpack libuuid libarchive binutils libcgroup ];
  propagatedBuildInputs = [ libmsgpack libev boost ];
  nativeBuildInputs = [ scatterOutputHook ];

  enableParallelBuilding = true;

  outputs = [ "out" "bin" ];

  patches = [ ./binutils-fix.patch ];

  preConfigure = ''
    sed -r -i -e "s,(boost_[^-]+)-mt,\1," CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    description = "An open platform to build your own PaaS clouds";
    homepage = https://github.com/cocaine/cocaine-core/wiki; 
    maintainers = [ maintainers.redbaron ];
    license = licenses.lgpl3;
    platforms = platforms.linux;
  };
}
