-- Moving the Frame itself
local _G = _G

local function onLogin(self)
	local wf = _G['WatchFrame']
	wf:ClearAllPoints()
	wf.ClearAllPoints = function() end
	wf:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -15)
	wf.SetPoint = function() end
	wf:SetHeight(650)
end

local f = CreateFrame("Frame")
f:SetScript("OnEvent", onLogin)
f:RegisterEvent("PLAYER_LOGIN")
-- Setting it's size
--TBD

-- Make it collapsed at login
--TBD