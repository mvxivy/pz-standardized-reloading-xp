local modOptions = require("ST_Reloading_ModOptions")
modOptions.init()

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

-- Build 42.13+: Magazine:getAmmoType() returns an AmmoType object, while older builds used a string.
-- ItemContainer:RemoveOneOf(...) no longer accepts AmmoType objects (and may be replaced by RemoveOneOfType).
local function normalizeFullType(s)
	if not s or s == "" then return nil end
	if s:find("%.") then return s end
	local mod, name = s:match("^([%w_]+):([%w_]+)$")
	if mod and name then
		mod = mod:gsub("^%l", string.upper)
		return mod .. "." .. name
	end
	-- If it's a bare type id, assume Base.
	if s:match("^[%w_]+$") then
		return "Base." .. s
	end
	return s
end

-- In B42.13+, AmmoType has getItemKey() which points at the actual inventory item type (e.g. Base.Bullets9mm, Base.556Bullets).
local function ammoTypeToItemKey(ammoType)
	if type(ammoType) == "string" then
		return ammoType
	end
	if ammoType and ammoType.getItemKey then
		local ok, key = pcall(function() return ammoType:getItemKey() end)
		if ok then return key end
	end
	-- Fallbacks for older/unknown objects.
	if ammoType and ammoType.getName then
		local ok, name = pcall(function() return ammoType:getName() end)
		if ok then return name end
	end
	if ammoType and ammoType.getFullType then
		local ok, ft = pcall(function() return ammoType:getFullType() end)
		if ok then return ft end
	end
	if ammoType and ammoType.getType then
		local ok, t = pcall(function() return ammoType:getType() end)
		if ok then return t end
	end
	return tostring(ammoType)
end

local function removeOneAmmoFromInventory(inv, ammoType)
	if not inv then return false end

	local key = normalizeFullType(ammoTypeToItemKey(ammoType))
	if not key or key == "" then return false end

	-- Make sure we won't remove twice: only attempt if it exists (recursively).
	local has = false
	if inv.contains then
		local ok, res = pcall(function() return inv:contains(key, true) end)
		if ok then
			has = res and true or false
		else
			ok, res = pcall(function() return inv:contains(key) end)
			has = ok and (res and true or false) or false
		end
	elseif inv.getItemFromType then
		local ok, item = pcall(function() return inv:getItemFromType(key) end)
		has = ok and item ~= nil
	end
	if not has then return false end

	-- Use the native API (supports recursive search via the boolean parameter).
	if inv.RemoveOneOf then
		local ok = pcall(function() inv:RemoveOneOf(key, true) end)
		if ok then return true end
		ok = pcall(function() inv:RemoveOneOf(key) end)
		if ok then return true end
	end

	-- Fallbacks (should be rare).
	if inv.RemoveOneOfType then
		local ok = pcall(function() inv:RemoveOneOfType(key) end)
		if ok then return true end
	end

	return false
end

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
		local inv = self.character:getInventory()
		if removeOneAmmoFromInventory(inv, self.magazine:getAmmoType()) then
			self.magazine:setCurrentAmmoCount(self.magazine:getCurrentAmmoCount() + 1);
		end
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