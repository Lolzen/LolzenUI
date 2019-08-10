local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddHealthPoints(self, unit)
	local HealthPoints = self.Health:CreateFontString(nil, "OVERLAY")
	HealthPoints:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.general["uf_general_hp_font"]), LolzenUIcfg.unitframes.general["uf_general_hp_font_size"], LolzenUIcfg.unitframes.general["uf_general_hp_font_flag"])
	HealthPoints:SetPoint(LolzenUIcfg.unitframes.general["uf_general_hp_anchor"], LolzenUIcfg.unitframes.general["uf_general_hp_posx"], LolzenUIcfg.unitframes.general["uf_general_hp_posy"])
	if LolzenUIcfg.unitframes.general["uf_use_val_and_perc"] == true then
		if LolzenUIcfg.unitframes.general["uf_perc_first"] == true then
			self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][perhp]%"..LolzenUIcfg.unitframes.general["uf_val_perc_divider"].."[lolzen:health]")
		else
			self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]"..LolzenUIcfg.unitframes.general["uf_val_perc_divider"].."[perhp]%")
		end
	elseif LolzenUIcfg.unitframes.general["uf_use_hp_percent"] == true and LolzenUIcfg.unitframes.general["uf_use_val_and_perc"] == false then
		self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][perhp]%")
	else
		self:Tag(HealthPoints, "[|cffc41f3b>dead<|r][|cff999999>offline<|r][lolzen:health]")
	end

	self.Health.value = HealthPoints
end