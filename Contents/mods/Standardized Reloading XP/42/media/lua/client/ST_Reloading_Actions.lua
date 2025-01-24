--*******************************************************************************
--**		Code made By:	Conqueror Koala, MaxIvy																									 **
--**		Mod: Standardized Reloading XP															 					 **
--** 		Date: 24-01-2025																									 		 **
--*******************************************************************************

local modOptions = require("ST_Reloading_ModOptions")

--Xp rewards are divided by 4 for actual xp values, so 1 turns into 1/4, or 0.25xp.
local xpReward = {1,2,3,4,6,8,12,20,40};
--				0.25xp, 0.5xp, 0.75xp, 1xp, ... 10xp
--Chance to get XP, one in X chance
local xpChance = {1,2,3,4,5,6,7,8,9,10};
-- one in one (1/1) = always
-- one in two (1/2) half the time, one in ten (1/10) one tenth of the time, etc.
-- Whether the use wants to keep the vanilla xp nerf at level 5 and above.
local xpNerf = {true,false};
--Xp rewards are divided by 4 for actual xp values, so 1 turns into 1/4, or 0.25xp.
local xpRewardForGunsWOMags = {1,2,3,4,6,8,12,20,40};
--				0.25xp, 0.5xp, 0.75xp, 1xp, ... 10xp
--Chance to get XP, one in X chance
local xpChanceForGunsWOMags = {1,2,3,4,5,6,7,8,9,10};
-- one in one (1/1) = always
-- one in two (1/2) half the time, one in ten (1/10) one tenth of the time, etc.
-- Whether the use wants to keep the vanilla xp nerf at level 5 and above.
local xpNerfForGunsWOMags = {true,false};

function ISReloadWeaponAction:animEvent(event, parameter)
	if event == 'loadFinished' then
		self:loadAmmo();
		local chance = xpChanceForGunsWOMags[tonumber(modOptions.ComboBoxChanceGunsWOMags:getValue())]
		local xp = xpRewardForGunsWOMags[tonumber(modOptions.ComboBoxRewardGunsWOMags:getValue())]

		local isNerfed = xpNerfForGunsWOMags[tonumber(modOptions.ComboBoxReductionGunsWOMags:getValue())]

		if (isNerfed and (self.character:getPerkLevel(Perks.Reloading) > 4)) 
		then
			chance = 3;
			xp = 1;
		end
		if ZombRand(chance) == 0 then
			self.character:getXp():AddXP(Perks.Reloading, xp);
		end
	end
	if event == 'playReloadSound' then
		if parameter == 'load' then
			if self.gun:getInsertAmmoSound() and self.gun:getCurrentAmmoCount() < self.gun:getMaxAmmo() then
				self.character:playSound(self.gun:getInsertAmmoSound());
			end
		elseif parameter == 'insertAmmoStart' then
			if not self.playedInsertAmmoStartSound and self.gun:getInsertAmmoStartSound() then
				self.playedInsertAmmoStartSound = true;
				self.character:playSound(self.gun:getInsertAmmoStartSound());
			end
		end
	end
	if event == 'changeWeaponSprite' then
		if parameter and parameter ~= '' then
			if parameter ~= 'original' then
				self:setOverrideHandModels(parameter, nil)
			else
				self:setOverrideHandModels(self.gun, nil)
			end
		end
	end
end

function ISLoadBulletsInMagazine:animEvent(event, parameter)
	if event == 'InsertBulletSound' then
		if self:isLoadFinished() then
			-- Fix for looping animation events arriving after loading finished.
			-- That's why 'PlaySound' isn't used instead.
			return
		end
		self.character:playSound(parameter);
	elseif event == 'InsertBullet' then
		if self:isLoadFinished() then
			-- Fix for looping animation events arriving after loading finished.
			return
		end
		local chance = xpChance[tonumber(modOptions.ComboBoxChance:getValue())];
		local xp = xpReward[tonumber(modOptions.ComboBoxReward:getValue())];

		local isNerfed = xpNerf[tonumber(modOptions.ComboBoxReduction:getValue())];

		if (isNerfed and (self.character:getPerkLevel(Perks.Reloading) > 4)) then
			chance = 5;
			xp = 1;
		end
		if ZombRand(chance) == 0 then
			self.character:getXp():AddXP(Perks.Reloading, xp);
		end
		self.character:getInventory():RemoveOneOf(self.magazine:getAmmoType());
		self.magazine:setCurrentAmmoCount(self.magazine:getCurrentAmmoCount() + 1);
	elseif event == 'loadFinished' then
		if self:isLoadFinished() then
			self.loadFinished = true
		end
	elseif event == 'playReloadSound' then
		if parameter == 'insertAmmoStart' then
			if not self.playedInsertAmmoStartSound and self.magazine:getInsertAmmoStartSound() then
				self.playedInsertAmmoStartSound = true;
				self.character:playSound(self.gun:getInsertAmmoStartSound());
			end
		end
	end
end