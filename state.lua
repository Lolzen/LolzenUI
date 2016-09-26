-- Moving the Frame itself
local function onLogin(self)
	local of = ObjectiveTrackerFrame
	of:ClearAllPoints()
	of.ClearAllPoints = function() end
	of:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -75)
	of.SetPoint = function() end
	of:SetHeight(650)
	of:SetScale(1.2)
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", onLogin)
f:RegisterEvent("PLAYER_LOGIN")