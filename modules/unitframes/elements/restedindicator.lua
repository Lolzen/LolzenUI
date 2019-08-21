local _, ns = ...

function ns.AddRestedIndicator(self, unit)
	local rest = self.Health:CreateTexture(nil, "OVERLAY")
	rest:SetSize(LolzenUIcfg.unitframes.player["uf_player_resting_size"], LolzenUIcfg.unitframes.player["uf_player_resting_size"])
	rest:SetPoint(LolzenUIcfg.unitframes.player["uf_player_resting_anchor"], self.Health, LolzenUIcfg.unitframes.player["uf_player_resting_posx"], LolzenUIcfg.unitframes.player["uf_player_resting_posy"])
	self.RestingIndicator = rest
end