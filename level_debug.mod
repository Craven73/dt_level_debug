return {
	run = function()
		fassert(rawget(_G, "new_mod"), "`level_debug` encountered an error loading the Darktide Mod Framework.")

		new_mod("level_debug", {
			mod_script       = "level_debug/scripts/mods/level_debug/level_debug",
			mod_data         = "level_debug/scripts/mods/level_debug/level_debug_data",
			mod_localization = "level_debug/scripts/mods/level_debug/level_debug_localization",
		})
	end,
	packages = {},
}
