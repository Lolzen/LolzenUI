local _, ns = ...
local oUF = ns.oUF
local LSM = LibStub("LibSharedMedia-3.0")

local PostUpdateHealth = function(Health, unit, min, max)
	if UnitIsDead(unit) then
		Health:SetValue(0)
	elseif UnitIsGhost(unit) then
		Health:SetValue(0)
	end

	local r, g, b = oUF:ColorGradient(min / max, 1, 1, 0, 0, 1, 1, 0, 0, 1, 0)
	Health.value:SetTextColor(r, g, b)
end

function ns.AddHealthBar(self, unit)
	local Health = CreateFrame("StatusBar", nil, self)
	Health:SetStatusBarTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	Health:SetFrameStrata("LOW")

	Health.colorTapping = unit ~= "raid"
	Health.colorDisconnected = true
	Health.colorClass = true
	Health.colorReaction = true

	Health:SetPoint("TOP")
	Health:SetPoint("LEFT")
	Health:SetPoint("RIGHT")

	self.Health = Health

	local bg = self:CreateTexture(nil, "BORDER")
	bg:SetAllPoints(self)
	bg:SetTexture(LSM:Fetch("statusbar", LolzenUIcfg.unitframes.general["uf_statusbar_texture"]))
	bg:SetVertexColor(0.3, 0.3, 0.3)
	bg:SetAlpha(1)
	self.Background = bg

	Health.PostUpdate = PostUpdateHealth
end