local config = require("ST_Reloading_Config")
local MVXIVY_Utils = require("MVXIVY_Utils")
local modOptions = {}

function modOptions.init()
	local UI = PZAPI.ModOptions:create(config.modId, config.modName)

	local ComboBoxFactory = MVXIVY_Utils.useComboBoxFactory(
		"ST_Reloading_",
		"UI_options_STRELOAD_B42_",
		UI
	)

	local ComboBoxReward = ComboBoxFactory{
		name="ComboBoxReward",
		label="reward_label",
		items={ "0.25xp", "0.5xp", "0.75xp", "1.0xp", "1.5xp", "2.0xp", "3.0xp", "5.0xp", "10.0xp" },
		defaultItem=4
		description="reward_description"
	}
	modOptions.ComboBoxReward = ComboBoxReward

	local ComboBoxChance = ComboBoxFactory{
		name="ComboBoxChance",
		label="chance_label",
		items={ "1/1", "1/2", "1/3", "1/4", "1/5", "1/6", "1/7", "1/8", "1/9", "1/10" },
		defaultItem=2
		description="chance_description"
	}
	modOptions.ComboBoxChance = ComboBoxChance

	options:addDescription(getText("UI_options_STRELOAD_B42_chance_description"))

	local ComboBoxReduction = options:addCheckBox(
		"ST_Reloading_ComboBoxReduction",
		getText("UI_options_STRELOAD_B42_reduction_label")
	)
	modOptions.ComboBoxReduction = ComboBoxReduction

	MVXIVY_Utils.addComboBoxItems(
		ComboBoxReduction, 
		{ 
			getText("UI_options_STRELOAD_B42_reduction_item_yes"),
			getText("UI_options_STRELOAD_B42_reduction_item_no") 
		},
		2
	)

	options:addDescription(getText("UI_options_STRELOAD_B42_reduction_description"))

	
end


--Default options.
local SETTINGS = { 
	options = {
		dropdown4 = 4,
		dropdown5 = 1,
		dropdown6 = 2,
	},
	names= {
		dropdown4 = "Xp reward (Guns without clips/mags)",
		dropdown5 = "Xp chance (Guns without clips/mags)",
		dropdown6 = "XP Reduction at lvl 5+ (Guns without clips/mags)",
	},
}

-- Connecting the options to the menu, so user can change them.
if ModOptions and ModOptions.getInstance then
	local settings = ModOptions:getInstance(SETTINGS)
	
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