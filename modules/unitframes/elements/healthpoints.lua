local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddHealthPoints(self, unit)
	local HealthPoints = self.Health:CreateFontString(nil, "OVERLAY")
	HealthPoints:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
	HealthPoints:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
	self:Tag(HealthPoints, "[dead][offline][lolzen:health]")

	self.Health.value = HealthPoints
end