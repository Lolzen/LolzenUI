local _, ns = ...

function ns.AddRaidMark(self, unit)
	local RaidTargetIndicator = self.Health:CreateTexture(nil, "OVERLAY")
	RaidTargetIndicator:SetSize(LolzenUIcfg.unitframes.general["uf_ri_size"], LolzenUIcfg.unitframes.general["uf_ri_size"])
	RaidTargetIndicator:SetPoint(LolzenUIcfg.unitframes.general["uf_ri_anchor"], self.Health, LolzenUIcfg.unitframes.general["uf_ri_posx"], LolzenUIcfg.unitframes.general["uf_ri_posy"])
	self.RaidTargetIndicator = RaidTargetIndicator
end