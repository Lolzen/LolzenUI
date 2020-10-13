local _, ns = ...

local UpdateThreat = function(self, event, unit)
	if self.unit ~= unit then return end

	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		local r, g, b = GetThreatStatusColor(status)
		self.Glow:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Glow:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

function ns.AddThreatBorder(self, unit)
	local Glow = CreateFrame("Frame", nil, self, "BackdropTemplate")
	Glow:SetBackdrop({
		edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	Glow:SetPoint("TOPLEFT", self, -5, 5)
	Glow:SetPoint("BOTTOMRIGHT", self, 5, -5)
	Glow:SetFrameLevel(2)
	self.Glow = Glow
	
	self.ThreatIndicator = {
		IsObjectType = function() end,
		Override = UpdateThreat,
	}
end