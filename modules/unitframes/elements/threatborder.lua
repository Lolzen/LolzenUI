local _, ns = ...

local UpdateThreat = function(self, event, unit)
	local status = UnitThreatSituation(unit)
	if status and status > 0 then
		local r, g, b = GetThreatStatusColor(status)
		self.Glow:SetBackdropBorderColor(r, g, b, 1)
	else
		self.Glow:SetBackdropBorderColor(0, 0, 0, 0)
	end
end

function ns.AddThreatBorder(self, unit)
	local Glow = CreateFrame("Frame", nil, self)
	Glow:SetBackdrop({
		edgeFile ="Interface\\AddOns\\LolzenUI\\media\\glow", edgeSize = 5,
		insets = {left = 4, right = 4, top = 4, bottom = 4}
	})
	Glow:SetPoint("TOPLEFT", self, -5, 5)
	Glow:SetPoint("BOTTOMRIGHT", self, 5, -5)
	Glow:SetFrameLevel(2)
	self.Glow = Glow
	table.insert(self.__elements, UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_SITUATION_UPDATE", UpdateThreat)
	self:RegisterEvent("UNIT_THREAT_LIST_UPDATE", UpdateThreat)
end