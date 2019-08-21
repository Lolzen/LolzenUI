local _, ns = ...

local CombatFade = function(self, event)
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
	if LolzenUIcfg.unitframes.general["uf_fade_combat"] == true then
		table.insert(self.__elements, CombatFade)
		self:RegisterEvent("PLAYER_REGEN_ENABLED", CombatFade, true)
		self:RegisterEvent('PLAYER_REGEN_DISABLED', CombatFade, true)
		self:RegisterEvent("PLAYER_TARGET_CHANGED", CombatFade, true)
		self:RegisterEvent("UNIT_TARGET", CombatFade)
	end
end