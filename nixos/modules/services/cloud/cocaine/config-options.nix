{ lib, pkgs }:
with lib;
let
    component = types.submodule (
            { ... }:
            { options = {
              type = mkOption { type = types.str; };
              args = mkOption { type = types.attrs; };
            };
	    });
in
{
    plugins = mkOption {
      type = types.listOf types.package;
      default = [ pkgs.cocaine_plugins.bin ];
      example = literalExample "[ pkgs.cocaine-plugins ]";
      description = "List of packages with Cocaine plugins to enable";
    };

    storages = mkOption {
      type = types.attrsOf component;
      default.core = { type = "files"; args.path = "/var/lib/cocaine"; };
      default.cache = { type = "files"; args.path = "/var/cache/cocaine"; };
    };

    loggers = mkOption {
      type = types.attrsOf component;
      default.core = { 
	type = "syslog"; 
	args = { identity = "cocaine"; verbosity = "info"; };
      };
    };

    user = mkOption {
      default = "cocaine";
      description = "User account under which Cocaine runs";
    };

    cfgExtra = mkOption {
     type = types.attrs;
     default = { };
     description = "Extra attributes to be merged with config set before building a JSON";
    };
}

