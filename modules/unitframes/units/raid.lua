local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupRaid = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.raid["uf_raid_width"], LolzenUIcfg.unitframes.raid["uf_raid_height"])

	if LolzenUIcfg.unitframes.raid["uf_raid_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.raid["uf_raid_hp_font"]), LolzenUIcfg.unitframes.raid["uf_raid_hp_font_size"], LolzenUIcfg.unitframes.raid["uf_raid_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.raid["uf_raid_hp_anchor"], LolzenUIcfg.unitframes.raid["uf_raid_hp_posx"], LolzenUIcfg.unitframes.raid["uf_raid_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -2)

	ns.AddLeadIndicator(self, unit)
	ns.AddRangeIndicator(self, unit)
	ns.AddReadycheckIndicator(self, unit)
	self.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes.raid["uf_raid_rc_size"], LolzenUIcfg.unitframes.raid["uf_raid_rc_size"])
	self.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes.raid["uf_raid_rc_anchor"], self.Health, LolzenUIcfg.unitframes.raid["uf_raid_rc_posx"], LolzenUIcfg.unitframes.raid["uf_raid_rc_posy"])

	ns.AddRoleIndicator(self, unit)
	self.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes.raid["uf_raid_ri_size"], LolzenUIcfg.unitframes.raid["uf_raid_ri_size"])
	self.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes.raid["uf_raid_ri_anchor"], self.Health, LolzenUIcfg.unitframes.raid["uf_raid_ri_posx"], LolzenUIcfg.unitframes.raid["uf_raid_ri_posy"])
	if LolzenUIcfg.unitframes.raid["uf_raid_showroleindicator"] == true then
		self.GroupRoleIndicator:Show()
	else
		self.GroupRoleIndicator:Hide()
	end
end