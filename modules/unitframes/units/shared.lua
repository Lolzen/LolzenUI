local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

function ns.shared(self, unit)
	self.colors.power["MANA"] = LolzenUIcfg.unitframes.powercolors[0]
	self.colors.power["RAGE"] = LolzenUIcfg.unitframes.powercolors[1]
	self.colors.power["FOCUS"] = LolzenUIcfg.unitframes.powercolors[2]
	self.colors.power["ENERGY"] = LolzenUIcfg.unitframes.powercolors[3]
	self.colors.power["COMBO_POINTS"] = LolzenUIcfg.unitframes.powercolors[4]
	self.colors.power["RUNES"] = LolzenUIcfg.unitframes.powercolors[5]
	self.colors.power["RUNIC_POWER"] = LolzenUIcfg.unitframes.powercolors[6]
	self.colors.power["SOUL_SHARDS"] = LolzenUIcfg.unitframes.powercolors[7]
	self.colors.power["LUNAR_POWER"] = LolzenUIcfg.unitframes.powercolors[8]
	self.colors.power["HOLY_POWER"] = LolzenUIcfg.unitframes.powercolors[9]
	self.colors.power["MAELSTROM"] = LolzenUIcfg.unitframes.powercolors[11]
	self.colors.power["CHI"] = LolzenUIcfg.unitframes.powercolors[12]
	self.colors.power["INSANITY"] = LolzenUIcfg.unitframes.powercolors[13]
	self.colors.power["ARCANE_CHARGES"] = LolzenUIcfg.unitframes.powercolors[16]
	self.colors.power["FURY"] = LolzenUIcfg.unitframes.powercolors[17]
	self.colors.power["PAIN"] = LolzenUIcfg.unitframes.powercolors[18]

	-- use custom reaction colors
	if LolzenUIcfg.modules["miscellaneous"] == true and LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
		self.colors.reaction = LolzenUIcfg.miscellaneous["misc_faction_colors"]
	end

	self:SetScript("OnEnter", UnitFrame_OnEnter)
	self:SetScript("OnLeave", UnitFrame_OnLeave)

	self:RegisterForClicks("AnyUp")

	ns.AddBorder(self, unit)
	ns.AddHealthBar(self, unit)
	ns.AddHealthPoints(self, unit)
end