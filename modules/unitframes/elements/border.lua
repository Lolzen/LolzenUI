local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddBorder(self, unit)
	local Border = CreateFrame("Frame", nil, self, "BackdropTemplate")
	Border:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	Border:SetPoint("TOPLEFT", self, -3, 3)
	Border:SetPoint("BOTTOMRIGHT", self, 3, -3)
	Border:SetBackdropBorderColor(0, 0, 0)
	Border:SetFrameLevel(3)
	self.Border = Border
end