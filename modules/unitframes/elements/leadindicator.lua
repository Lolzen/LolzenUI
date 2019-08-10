local _, ns = ...

function ns.AddLeadIndicator(self, unit)
	local lead = self.Health:CreateTexture(nil, "OVERLAY")
	lead:SetSize(LolzenUIcfg.unitframes.general["uf_lead_size"], LolzenUIcfg.unitframes.general["uf_lead_size"])
	lead:SetPoint(LolzenUIcfg.unitframes.general["uf_lead_anchor"], self.Health, LolzenUIcfg.unitframes.general["uf_lead_posx"], LolzenUIcfg.unitframes.general["uf_lead_posy"])
	self.LeaderIndicator = lead
end