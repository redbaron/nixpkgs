{ pkgs }:
pkgs.stdenv.mkDerivation {
name = "eblob";
src = pkgs.fetchgit {
url = git://github.com/reverbrain/eblob.git;
rev = "v0.21.31";
};
buildInputs = with pkgs; [ cmake boost python ];
}