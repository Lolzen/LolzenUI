local _, ns = ...

local CombatFade = function(self, event)
	if LolzenUIcfg.unitframes.general["uf_fade_combat"] == false then return end
	local unit = self.unit
	-- the elements which are to be faded
	local elements = {
		self.Health,
		self.Power,
		self.Border,
		self.Panel,
		self.Background,
	}
	local combat = UnitAffectingCombat(unit)
	for _, element in pairs(elements) do
		if combat then
			if element:GetAlpha() == LolzenUIcfg.unitframes.general["uf_fade_combat_incombat"] then return end
			UIFrameFadeIn(element, 0.3, element:GetAlpha(), LolzenUIcfg.unitframes.general["uf_fade_combat_incombat"])
		else
			if element:GetAlpha() == LolzenUIcfg.unitframes.general["uf_fade_combat_outofcombat"] then return end
			UIFrameFadeOut(element, 0.3, element:GetAlpha(), LolzenUIcfg.unitframes.general["uf_fade_combat_outofcombat"])
		end
	end
end

function ns.AddCombatFade(self, unit)
	table.insert(self.__elements, CombatFade)
	if LolzenUIcfg.unitframes.general["uf_fade_combat"] == true then
		self:RegisterEvent("PLAYER_REGEN_ENABLED", CombatFade, true)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', CombatFade, true)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", CombatFade, true)
		self:RegisterEvent("UNIT_TARGET", CombatFade)
	end
end

function ns.EnableCombatFade(self, unit)
	self:RegisterEvent("PLAYER_REGEN_ENABLED", CombatFade, true)
	self:RegisterEvent('PLAYER_REGEN_DISABLED', CombatFade, true)
	self:RegisterEvent("PLAYER_TARGET_CHANGED", CombatFade, true)
	self:RegisterEvent("UNIT_TARGET", CombatFade)
end

function ns.DisableCombatFade(self, unit)
	self:UnregisterEvent("PLAYER_REGEN_ENABLED", CombatFade, true)
	self:UnregisterEvent('PLAYER_REGEN_DISABLED', CombatFade, true)
	self:UnregisterEvent("PLAYER_TARGET_CHANGED", CombatFade, true)
	self:UnregisterEvent("UNIT_TARGET", CombatFade)
	local elements = {
		self.Health,
		self.Power,
		self.Border,
		self.Panel,
		self.Background,
	}
	for _, element in pairs(elements) do
		UIFrameFadeIn(element, 0.3, element:GetAlpha(), 1)
	end
end