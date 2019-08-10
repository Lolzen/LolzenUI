local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.SetupParty = function(self, unit)
	ns.shared(self, unit)

	self:SetSize(LolzenUIcfg.unitframes.targettarget["uf_targettarget_width"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_height"])

	if LolzenUIcfg.unitframes.targettarget["uf_targettarget_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font"]), LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_size"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_anchor"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posx"], LolzenUIcfg.unitframes.targettarget["uf_targettarget_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

	ns.AddLeadIndicator(self, unit)
	ns.AddRaidMark(self, unit)
	ns.AddRangeIndicator(self, unit)
	ns.AddReadycheckIndicator(self, unit)
	self.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_rc_size"], LolzenUIcfg.unitframes.party["uf_party_rc_size"])
	self.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_rc_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_rc_posx"], LolzenUIcfg.unitframes.party["uf_party_rc_posy"])

	if LolzenUIcfg.unitframes.party["uf_party_showroleindicator"] == true then
		ns.AddRoleIndicator(self, unit)
		self.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_ri_size"], LolzenUIcfg.unitframes.party["uf_party_ri_size"])
		self.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_ri_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_ri_posx"], LolzenUIcfg.unitframes.party["uf_party_ri_posy"])
	end
end