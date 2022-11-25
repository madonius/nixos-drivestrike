{ config, lib, pkgs, ... }:
let
  inherit (lib) escapeShellArgs mkEnableOption mkIf mkOption types;

  cfg = config.services.drivestrike;
in {
  options.services.drivestrike = {
	enable = mkEnableOption (lib.mdDoc "drivestrike");

	systemd.services.drivestrike = {
	  description = "Drivestrike Client Service";
	  after = [ "network.target" "drivestrike-lock.service" ];
	  serviceConfig = {
		Type = "simple";
		Restart = "always";
		RestartSec = 10;
		ExecStart = "${out}/bin/drivestrike run";
		SyslogIdentifiert = "drivestrike";
	  };
	  wantedBy = [ "multi-user.target" ];
	};
  }
