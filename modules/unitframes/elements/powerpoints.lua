local _, ns = ...

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

function ns.AddPowerPoints(self, unit)
	local PowerPoints = self.Power:CreateFontString(nil, "OVERLAY")
	PowerPoints:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 18, "THINOUTLINE")
	self:Tag(PowerPoints, "[powercolor][lolzen:power]")
	self.Power.value = PowerPoints
end
