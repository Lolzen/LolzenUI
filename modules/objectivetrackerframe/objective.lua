--// objectivetracker // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["objectivetracker"] == false then return end

		local of = ObjectiveTrackerFrame
		--local hm = ObjectiveTrackerFrame.HeaderMenu
		--local of_title = of.HeaderMenu.Title

		of:ClearAllPoints()
		of.ClearAllPoints = function() end
		of:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 30, -30)
		of.SetPoint = function() end
		of:SetHeight(650)
		ObjectiveTracker_Collapse()
		of.HeaderMenu.Title:SetPoint("TOPLEFT", UIParent, "TOPLEFT", -140, -35)
	end
end)

local f2 = CreateFrame("Frame")
f2:RegisterEvent("PLAYER_REGEN_DISABLED")
f2:RegisterEvent("PLAYER_REGEN_ENABLED")

function f2.PLAYER_REGEN_DISABLED()
	ObjectiveTracker_Collapse()
end

function f2.PLAYER_REGEN_ENABLED()
	local of = ObjectiveTrackerFrame
	if of.collapsed and not InCombatLockdown() then
		ObjectiveTracker_Expand()
	end
end