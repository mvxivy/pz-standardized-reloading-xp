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
		defaultItem=4,
		description="reward_description"
	}
	modOptions.ComboBoxReward = ComboBoxReward

	local ComboBoxChance = ComboBoxFactory{
		name="ComboBoxChance",
		label="chance_label",
		items={ "1/1", "1/2", "1/3", "1/4", "1/5", "1/6", "1/7", "1/8", "1/9", "1/10" },
		defaultItem=2,
		description="chance_description"
	}
	modOptions.ComboBoxChance = ComboBoxChance

	local ComboBoxReduction = ComboBoxFactory{
		name="ComboBoxReduction",
		label="reduction_label",
		items={ 
			getText("UI_options_STRELOAD_B42_reduction_item_yes"),
			getText("UI_options_STRELOAD_B42_reduction_item_no") 
		},
		defaultItem=1,
		description="reduction_description"
	}
	modOptions.ComboBoxReduction = ComboBoxReduction

	local	ComboBoxRewardGunsWOMags = ComboBoxFactory{
		name="ComboBoxRewardGunsWOMags",
		label="reward_guns_wo_mags_label",
		items={ "0.25xp", "0.5xp", "0.75xp", "1.0xp", "1.5xp", "2.0xp", "3.0xp", "5.0xp", "10.0xp" },
		defaultItem=4,
		description="reward_guns_wo_mags_description"
	}
	modOptions.ComboBoxRewardGunsWOMags = ComboBoxRewardGunsWOMags

	local ComboBoxChanceGunsWOMags = ComboBoxFactory{
		name="ComboBoxChanceGunsWOMags",
		label="chance_guns_wo_mags_label",
		items={ "1/1", "1/2", "1/3", "1/4", "1/5", "1/6", "1/7", "1/8", "1/9", "1/10" },
		defaultItem=1,
		description="chance_guns_wo_mags_description"
	}
	modOptions.ComboBoxChanceGunsWOMags = ComboBoxChanceGunsWOMags

	local ComboBoxReductionGunsWOMags = ComboBoxFactory{
		name="ComboBoxReductionGunsWOMags",
		label="reduction_guns_wo_mags_label",
		items={ 
			getText("UI_options_STRELOAD_B42_reduction_guns_wo_mags_item_yes"),
			getText("UI_options_STRELOAD_B42_reduction_guns_wo_mags_item_no") 
		},
		defaultItem=1,
		description="reduction_guns_wo_mags_description"
	}
	modOptions.ComboBoxReductionGunsWOMags = ComboBoxReductionGunsWOMags
end

return modOptions