--Default options.
local SETTINGS = { 
	options = {
		dropdown1 = 4,
		dropdown2 = 1,
		dropdown3 = 2,
		dropdown4 = 4,
		dropdown5 = 1,
		dropdown6 = 2,
	},
	names= {
		dropdown1 = "Xp reward (Clips and Magazines)",
		dropdown2 = "Xp chance (Clips and Magazines)",
		dropdown3 = "XP Reduction at lvl 5+ (Clips and Magazines)",
		dropdown4 = "Xp reward (Guns without clips/mags)",
		dropdown5 = "Xp chance (Guns without clips/mags)",
		dropdown6 = "XP Reduction at lvl 5+ (Guns without clips/mags)",
	},
	mod_id = "STRELOAD",
	mod_shortname = "Standardized Reloading XP",
}

-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then
	local settings = ModOptions:getInstance(SETTINGS)
	
	local drop1 = settings:getData("dropdown1")
	drop1[1] = "0.25xp(vanilla lvl 5-10)"
	drop1[2] = "0.5xp"
	drop1[3] = "0.75xp"
	drop1[4] = "1.0xp(vanilla lvl 0-4)"
	drop1[5] = "1.5xp"
	drop1[6] = "2.0xp"
	drop1[7] = "3.0xp"
	drop1[8] = "5.0xp"
	drop1[9] = "10.0xp"
	drop1.tooltip = "Xp gained each time you pass the 1 in X chance. (Clips and Mags)"
	local drop2 = settings:getData("dropdown2")
	drop2[1] = "1(xp every bullet)"
	drop2[2] = "2(vanilla lvl 0-4)"
	drop2[3] = "3"
	drop2[4] = "4"
	drop2[5] = "5(vanilla lvl 5-10)"
	drop2[6] = "6"
	drop2[7] = "7"
	drop2[8] = "8"
	drop2[9] = "9"
	drop2[10] = "10"
	drop2.tooltip = "Chance to get xp reward, one in X (1/X), each bullet loaded. Setting 1 means xp always rewarded, 2 means xp rewarded half(1/2) the time, etc. (Clips and Mags)"
	local drop3 = settings:getData("dropdown3")
	drop3[1] = "Yes. Keep the vanilla XP reduction. (Clips and Mags)"
	drop3[2] = "No. Remove the vanilla XP reduction. (Clips and Mags)"
	drop3.tooltip = "Vanilla game is set to 'Yes'.  This lowers your xp gains from pistol clips and rifle magazines when you hit Reloading level 5 or beyond."
	
	
	local drop4 = settings:getData("dropdown4")
	drop4[1] = "0.25xp(vanilla lvl 5-10)"
	drop4[2] = "0.5xp"
	drop4[3] = "0.75xp"
	drop4[4] = "1.0xp(vanilla lvl 0-4)"
	drop4[5] = "1.5xp"
	drop4[6] = "2.0xp"
	drop4[7] = "3.0xp"
	drop4[8] = "5.0xp"
	drop4[9] = "10.0xp"
	drop4.tooltip = "Xp gained each time you pass the 1 in X chance. (Guns without clips/mags)"
	local drop5 = settings:getData("dropdown5")
	drop5[1] = "1(xp every bullet, also is vanilla lvl 0-4)"
	drop5[2] = "2"
	drop5[3] = "3(vanilla lvl 5-10)"
	drop5[4] = "4"
	drop5[5] = "5"
	drop5[6] = "6"
	drop5[7] = "7"
	drop5[8] = "8"
	drop5[9] = "9"
	drop5[10] = "10"
	drop5.tooltip = "Chance to get xp reward, one in X (1/X), each bullet loaded. Setting 1 means xp always rewarded, 2 means xp rewarded half(1/2) the time, etc. (Guns without clips/mags)"
	local drop6 = settings:getData("dropdown6")
	drop6[1] = "Yes. Keep the vanilla XP reduction. (Guns without clips/mags)"
	drop6[2] = "No. Remove the vanilla XP reduction. (Guns without clips/mags)"
	drop6.tooltip = "Vanilla game is set to 'Yes'.  This lowers your xp gains from Revolvers, Shotguns, and any other guns that do not use a clip or magazine when you hit Reloading level 5 or beyond."
	
end

StandardizedReloadingXP_global = {}
StandardizedReloadingXP_global.SETTINGS = SETTINGS