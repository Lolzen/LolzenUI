local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

function ns.AddInfoPanel(self, unit)
	local panel = CreateFrame("Frame")
	panel:SetParent(self)
	panel:SetSize(self:GetWidth(), 20)
	panel:SetFrameLevel(3)
	panel:SetPoint("TOP", self.Health, "BOTTOM", 0, -4)
	self.Panel = panel

	local Panelborder = CreateFrame("Frame", nil, self, "BackdropTemplate")
	Panelborder:SetBackdrop({
		bgFile = "Interface\\AddOns\\LolzenUI\\media\\statusbar",
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 2, right = 2, top = 3, bottom = 2},
	})
	Panelborder:SetPoint("TOPLEFT", panel, -3, 3)
	Panelborder:SetPoint("BOTTOMRIGHT", panel, 3, -1)
	Panelborder:SetBackdropBorderColor(0, 0, 0)
	Panelborder:SetFrameLevel(3)
	Panelborder:SetBackdropColor(0, 0, 0, 0.8)

	local level = self.Health:CreateFontString(nil, "OVERLAY")
	level:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE") 
	self:Tag(level, "[difficulty][level][shortclassification] [arenaspec]")
	self.Level = level

	local name = self.Health:CreateFontString(nil, "OVERLAY")
	name:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12, "THINOUTLINE")
	name:SetTextColor(1, 1, 1)
	self:Tag(name, "[name]")
	self.Name = name
end