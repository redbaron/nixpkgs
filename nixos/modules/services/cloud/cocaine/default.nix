{ config, lib, pkgs, ... }:
with lib;
let
#    cfg = config.services.cocaine;
    pluginsDir = cfg: pkgs.runCommand "link_all_plugins" { } 
    ''
      mkdir -p $out
      for p in ${concatStringsSep " " cfg.plugins}; do
      	  ln -s $p/lib/cocaine/*.cocaine-plugin $out/ #*/
      done
    '';

    mkConf = name: cfg: { 
      version = 2;
      paths.plugins = pluginsDir cfg;
      paths.runtime = "/run/cocaine/${name}";
      storages = cfg.storages;
      loggers = cfg.loggers;
    } // cfg.cfgExtra;
    
    confFile = name: cfg: pkgs.writeText "cocaine.conf" (builtins.toJSON (mkConf name cfg));
in
{
    options.services.cocaine = {
        enable = mkEnableOption "Cocaine";
	
	instances = mkOption {
	    type = types.attrsOf (types.submodule ({  
                options = import ./config-options.nix { inherit lib pkgs; };
            }));
	    default = {};
        };
    };
    	
    config = mkIf config.services.cocaine.enable {
      users.extraUsers.cocaine = {
          description = "Cocaine PAAS server user";
          group = "cocaine";
	  uid = config.ids.uids.cocaine;
      }; 
 
      users.extraGroups.cocaine.gid = config.ids.gids.cocaine; 

      systemd.services = mapAttrs' (name: cfg: nameValuePair "cocaine@${name}" {
	description = "Cocaine PAAS instance ${name}";

	after = [ "network.target" ];
	
	preStart = 
	  ''
	    mkdir -p /run/cocaine/${name}
	    chown -R ${cfg.user} /run/cocaine/${name}
	  '';

	serviceConfig = {
	  ExecStart = "${pkgs.cocaine_core.bin}/bin/cocaine-runtime -c ${confFile name cfg}";
	  User = cfg.user;
	  PermissionsStartOnly = true;
	};
      }) config.services.cocaine.instances; 
    };
}
