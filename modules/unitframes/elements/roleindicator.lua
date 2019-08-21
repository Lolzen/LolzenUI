local _, ns = ...

function ns.AddRoleIndicator(self, unit)
	local role = self.Health:CreateTexture(nil, "OVERLAY")
	self.GroupRoleIndicator = role
end