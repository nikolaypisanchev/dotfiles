{ config, lib, pkgs, ... }:
{

	options = {
	  asd = lib.mkOption {
	    type = lib.types.str;

	  };

	};

  	config = {
            asd = "koko";

	};
}
