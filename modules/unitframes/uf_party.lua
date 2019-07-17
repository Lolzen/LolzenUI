--// unitframes: party // --

local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

ns.SetupParty = function(self, ...)
	ns.shared(self, ...)

	if LolzenUIcfg.unitframes.party["uf_party_use_own_hp_font_settings"] == true then
		self.Health.value:SetFont(LSM:Fetch("font", LolzenUIcfg.unitframes.party["uf_party_hp_font"]), LolzenUIcfg.unitframes.party["uf_party_hp_font_size"], LolzenUIcfg.unitframes.party["uf_party_hp_font_flag"])
		self.Health.value:SetPoint(LolzenUIcfg.unitframes.party["uf_party_hp_anchor"], LolzenUIcfg.unitframes.party["uf_party_hp_posx"], LolzenUIcfg.unitframes.party["uf_party_hp_posy"])
	end

	self.Border:SetPoint("TOPLEFT", self, -3, 3)
	self.Border:SetPoint("BOTTOMRIGHT", self, 3, -3)

	self:SetSize(LolzenUIcfg.unitframes.party["uf_party_width"], LolzenUIcfg.unitframes.party["uf_party_height"])

	if LolzenUIcfg.unitframes.party["uf_party_showroleindicator"] == true then
		self.GroupRoleIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_ri_size"], LolzenUIcfg.unitframes.party["uf_party_ri_size"])
		self.GroupRoleIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_ri_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_ri_posx"], LolzenUIcfg.unitframes.party["uf_party_ri_posy"])
	end

	self.ReadyCheckIndicator:SetSize(LolzenUIcfg.unitframes.party["uf_party_rc_size"], LolzenUIcfg.unitframes.party["uf_party_rc_size"])
	self.ReadyCheckIndicator:SetPoint(LolzenUIcfg.unitframes.party["uf_party_rc_anchor"], self.Health, LolzenUIcfg.unitframes.party["uf_party_rc_posx"], LolzenUIcfg.unitframes.party["uf_party_rc_posy"])
end