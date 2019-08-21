local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddDebuffHighlight(self, unit)
	local dbh = self.Health:CreateTexture(nil, "OVERLAY")
	dbh:SetAllPoints(self.Health)
	dbh:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	dbh:SetVertexColor(0, 0, 0, 0)
	self.DebuffHighlight = dbh
	self.DebuffHighlightAlpha = 0.5
	self.DebuffHighlightFilter = true
end