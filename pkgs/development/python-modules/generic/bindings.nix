{ python }:
{ name

# seeding pkg,  which has "python" output where to copy files from
, package

# by default prefix `name` e.g. "python3.3-${name}"
, namePrefix ? python.libPrefix + "-"
} @ attrs:
let 
  # version of "seeding" package rebuilt with current python version
  rebuiltWithPython = package.override {inherit python;};
in
python.stdenv.mkDerivation ( attrs // {
  name = namePrefix + name;
  
  installPhase = "cp -a * $out/ ";

  src = rebuiltWithPython.python;
    
  meta = package.meta;
})