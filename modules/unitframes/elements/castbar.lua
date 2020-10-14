local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local PostCastStart = function(Castbar, unit)
	if Castbar.notInterruptible then
		Castbar.Icon:SetDesaturated(true)
	else
		Castbar.Icon:SetDesaturated(false)
	end
end

function ns.AddCastBar(self, unit)
	local Castbar = CreateFrame("StatusBar", nil, self)
	Castbar:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Castbar:SetFrameStrata("MEDIUM")
	Castbar:SetParent(self)
	self.Castbar = Castbar

	local cbbg = Castbar:CreateTexture(nil, "BORDER")
	cbbg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	cbbg:SetVertexColor(0.3, 0.3, 0.3)
	cbbg:SetAlpha(1)
	self.Castbar.background = cbbg

	local cbborder = CreateFrame("Frame", nil, self, "BackdropTemplate")
	cbborder:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	cbborder:SetParent(Castbar)
	cbborder:SetBackdropBorderColor(0, 0, 0)
	cbborder:SetFrameLevel(3)
	self.Castbar.border = cbborder

	local Spark = Castbar:CreateTexture(nil, "OVERLAY")
	Spark:SetBlendMode("ADD")
	Spark:SetPoint("CENTER", Castbar:GetStatusBarTexture(), "RIGHT", 0, 0)
	self.Castbar.Spark = Spark

	local icon = Castbar:CreateTexture(nil, "BACKGROUND")
	icon:SetDrawLayer("OVERLAY", 0)
	self.Castbar.Icon = icon

	local iconborder = CreateFrame("Frame", nil, self, "BackdropTemplate")
	iconborder:SetBackdrop({
		edgeFile = LSM:Fetch("border", LolzenUIcfg.unitframes.general["uf_border"]), edgeSize = 12,
		insets = {left = 4, right = 4, top = 4, bottom = 4},
	})
	iconborder:SetParent(Castbar)
	iconborder:SetPoint("TOPLEFT", icon, -2, 3)
	iconborder:SetPoint("BOTTOMRIGHT", icon, 2, -2)
	iconborder:SetBackdropBorderColor(0, 0, 0)
	iconborder:SetFrameLevel(3)
	self.Castbar.Iconborder = iconborder

	local Time = Castbar:CreateFontString(nil, "OVERLAY")
	Time:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "OUTLINE")
	self.Castbar.Time = Time

	local cbtext = Castbar:CreateFontString(nil, "OVERLAY")
	cbtext:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 12, "OUTLINE")
	self.Castbar.Text = cbtext

	local Shield = Castbar:CreateTexture(nil, "ARTWORK")
	Shield:SetTexture("Interface\\AddOns\\LolzenUI\\media\\shield")
	self.Castbar.Shield = Shield

	Castbar.PostChannelStart = PostCastStart
	Castbar.PostCastStart = PostCastStart
end