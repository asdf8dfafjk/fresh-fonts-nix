{config, pkgs, lib, ...}:

let 
	fillerFontNameList =
	[
		"Noto Sans CJK SC"
		"HanaMinA"
		"HanaMinB"
		"Noto Emoji"
		"Noto Color Emoji"
		"Gargi-1.2b"
	];

	font-derivs = ( import ./font-derivs.nix{ inherit pkgs lib; } );

	fillerFontPackages = 
	[
		# Don't (old) MS fonts, like Arial etc
		# pkgs.corefonts

		# No default monospace 
		# No default sans
		# No default serif

		# Languages
		# Huge, don't change much

		# pkgs.versioned."latest".ttf-tw-moe
		pkgs.versioned."previous".noto-fonts-cjk
		pkgs.versioned."latest".noto-fonts-emoji
		pkgs.versioned."latest".hanazono
		( import ../../custom/ttf-indic-otf.nix { inherit pkgs; } )
	];

	num_specializations = 7;

	switcher = (
		pkgs.writeShellScriptBin
			"switch_to_random_nixos_specialisation"
			''
				ID=${"$"}{1:-DUMMY}

				if [ $ID = "DUMMY" ] 
				then
					ID=$(( 1 + $RANDOM % ${builtins.toString num_specializations} ))
				fi

				echo "Activating specialisation $ID"
				/nix/var/nix/profiles/system/specialisation/$ID/activate
				exit $ID
			''
	);
in
{
	environment.systemPackages = 
	[
		pkgs.versioned."latest".gnome3.gnome-font-viewer
		pkgs.versioned."latest".fontpreview
		pkgs.versioned."latest".fontforge-gtk
		pkgs.versioned."latest".birdfont
		pkgs.versioned."latest".xorg.xfd
		switcher
	];

	fonts = {
		enableDefaultFonts = false;
		fonts = fillerFontPackages;

		# /run/current-system/sw/share/X11-fonts
		fontDir.enable		= false;

		fontconfig.hinting = {
			enable = true;
			autohint = true;
		};

		# For GO MONO
		# Try changing font thickness: 
		# https://work.lisk.in/2020/07/18/font-weight-300.html

		# This works only for latin locales
		# We have zh locale.
		# So go edit that.
		fontconfig.defaultFonts = {
			monospace = [
				# Only one of these fonts is installed at any time
				# So dont worry about the order

				"CamingoCode"
				"Cascadia Code"
				"Comic Mono"
				"Code New Roman"
				"DaddyTimeMono"
				"t1xtt"
				"mononoki"
			] ++ fillerFontNameList ;
			sansSerif = [
				# Don't remember why we have 2 but doesn't matter 
				"PT Sans" "PT Sans Regular"
				"Delicious"
				"Signika"
				"Proza Libre"
				"Imprima"
				"Rufscript"
			] ++ fillerFontNameList ;
			serif = [
				"Gentium Plus"
				"Bree Serif"
				"Alegreya"
				"Roboto Slab"
			] ++ fillerFontNameList ;
		};


		# 90 degrees CCW  ~ vbgr
		# fontconfig.subpixel.rgba = "vbgr";
	};


	## !!! DONT REMOVE, FIX rendering
	## See; http://people.oregonstate.edu/~youngjef/posts-output/2018-07-09-xmonad-on-nixos.html
	## in firefox for example of beauty

	specialisation."1" = {
		configuration.fonts.fonts = [ 
			pkgs.versioned."latest".cascadia-code
			pkgs.versioned."latest".paratype-pt-sans
			font-derivs.bree-serif
		];
	};
	
	specialisation."2" = {
		configuration.fonts.fonts = [ 
			font-derivs.comic-mono
			font-derivs.delicious
			font-derivs.gentium-plus
		];
	};
	
	specialisation."3" = {
		configuration.fonts.fonts = [ 
			font-derivs.monaco
			font-derivs.signika
			font-derivs.roboto-slab
		];
	};
	
	specialisation."4" = {
		configuration.fonts.fonts = [ 
			font-derivs.camingo-code
			font-derivs.proza-libre
			font-derivs.alegreya
		];
	};
	
	specialisation."5" = {
		configuration.fonts.fonts = [ 
			font-derivs.daddy-time-mono
			font-derivs.imprima
			font-derivs.alegreya
		];
	};
	
	specialisation."6" = {
		configuration.fonts.fonts = [ 
			font-derivs.t1xtt
			font-derivs.imprima
			font-derivs.roboto-slab
		];
	};
	
	
	specialisation."7" = {
		configuration.fonts.fonts = [ 
			pkgs.versioned."latest".mononoki
			font-derivs.imprima
			font-derivs.gentium-plus
		];
	};

	################################################################
	## EDIT num_specializations variable after adding to the list ##
	################################################################
	
	security.doas = {
		extraRules = 
		[
			{
				groups = [ "wheel" ];
				cmd = "switch_to_random_nixos_specialisation";
				noPass = true;
			}
		];
	};
}
