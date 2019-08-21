local _, ns = ...
local LSM = LibStub("LibSharedMedia-3.0")

local PostUpdatePower = function(Power, unit, min, max)
	local parent = Power:GetParent()
	if not Power then return end
	if parent.PowerDivider then
		if min > 0 then
			parent.PowerDivider:SetAlpha(1)
		else
			parent.PowerDivider:SetAlpha(0)
		end
	end
end

function ns.AddPowerBar(self, unit)
	local Power = CreateFrame("StatusBar", nil, self)
	Power:SetHeight(2)
	Power:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Power:SetPoint("LEFT")
	Power:SetPoint("RIGHT")
	Power:SetPoint("TOP", self.Health, "BOTTOM", 0, 2)
	Power:SetFrameStrata("MEDIUM")
	Power.colorPower = true

	self.Power = Power

	local PowerDivider = Power:CreateTexture(nil, "OVERLAY")
	PowerDivider:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")
	PowerDivider:SetSize(self:GetWidth(), 1)
	PowerDivider:SetPoint("TOPLEFT", self.Power, 0, 1)
	PowerDivider:SetDrawLayer("BACKGROUND", 1)
	PowerDivider:SetVertexColor(0, 0, 0)
	self.PowerDivider = PowerDivider

	Power.PostUpdate = PostUpdatePower
end
