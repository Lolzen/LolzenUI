local _, ns = ...
local oUF = ns.oUF
local LSM = LibStub("LibSharedMedia-3.0")

local PostUpdatePower = function(Power, unit, cur, max, curModifier, maxModifier)
	local parent = Power:GetParent()
	if not Power then return end
	
	if parent.PowerDivider then
		-- Use curModifier since cur might be secret
		-- Check if we have power (modifier > 0 means we have some power)
		if curModifier and curModifier > 0 then
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
	
	-- Set smoothing to the correct enum value
	Power.smoothing = Enum.StatusBarInterpolation.Smooth
	
	-- Updated option name from colorPower to colorPowerSmooth in 13.0.0
	-- But colorPower still exists for basic power coloring
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