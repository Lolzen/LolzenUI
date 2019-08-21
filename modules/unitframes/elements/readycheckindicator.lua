local _, ns = ...

function ns.AddReadycheckIndicator(self, unit)
	local rc = self.Health:CreateTexture(nil, "OVERLAY")
	self.ReadyCheckIndicator = rc
end