local _, ns = ...

function ns.AddRangeIndicator(self, unit)
	self.Range = {
		insideAlpha = 1,
		outsideAlpha = LolzenUIcfg.unitframes.general["uf_fade_outofreach_alpha"],
	}
end