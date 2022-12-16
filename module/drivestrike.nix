{ config, lib, pkgs, ... }:
let
  inherit (lib) escapeShellArgs mkEnableOption mkIf mkOption types;

  cfg = config.services.drivestrike;
in {
  options.services.drivestrike = {
	enable = mkEnableOption (lib.mdDoc "drivestrike");

	registrationKey = mkOption {
	  type = types.str;
	  default = "";
	  example = "user@example.com";
	  description = lib.mdDoc ''
		Drivestrike registation key
	  '';
	}

	config = mkIf cfg.enable {
	  services.drivestrike.registrationKey =

	  systemd.services.drivestrike = {
		description = "Drivestrike Client Service";
		after = [ "network.target" ];
		serviceConfig = {
		  Type = "simple";
		  Restart = "always";
		  RestartSec = 10;
		  ExecStart = "${out}/bin/drivestrike run";
		  SyslogIdentifiert = "drivestrike";
		};
		wantedBy = [ "multi-user.target" ];
	  };
	};
  }
