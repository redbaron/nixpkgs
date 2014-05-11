{ config, lib, pkgs, ... }:
with lib;
let
    cfg = config.services.cocaine;
    component = types.submodule (
            { ... }:
            { options = {
              type = mkOption { type = types.str; };
              args = mkOption { type = types.attrs; };
            };
	    }
	    );

    pluginsDir = pkgs.runCommand "link_all_plugins" { } 
    ''
      mkdir -p $out
      for p in ${concatStringsSep " " cfg.plugins}; do
      	  ln -s $p/lib/cocaine/*.cocaine-plugin $out/ #*/
      done
    '';

    conf = { 
      version = 2;
      paths.plugins = pluginsDir;
      paths.runtime = "/run/cocaine";
      storages = cfg.storages;
      loggers = cfg.loggers;
    } // cfg.cfgExtra;
    
    confFile = pkgs.writeText "cocaine.conf" (builtins.toJSON conf);
in
{
    options.services.cocaine = {
        enable = mkEnableOption "Cocaine";

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
	 description = "Extra attributes to be merged with config set before building a JSON"
        };
    };
    	
  config = mkIf config.services.cocaine.enable {
      users.extraUsers.cocaine = {
          description = "Cocaine PAAS server user";
          group = "cocaine";
	  uid = config.ids.uids.cocaine;
      }; 
 
      users.extraGroups.cocaine.gid = config.ids.gids.cocaine; 

      systemd.services.cocaine = {
	description = "Cocaine PAAS";

	wantedBy = [ "multi-user.target" ];

	preStart = 
	  ''
	    mkdir -p /run/cocaine
	    chown -R ${cfg.user} /run/cocaine
	  '';

	serviceConfig = {
	  ExecStart = "${pkgs.cocaine_core.bin}/bin/cocaine-runtime -c ${confFile}";
	  User = cfg.user;
	  PermissionsStartOnly = true;
	};
      }; 
  };
}
