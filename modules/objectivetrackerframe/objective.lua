--// objectivetracker // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["objectivetracker"] == false then return end

		local of = ObjectiveTrackerFrame

		of:ClearAllPoints()
		of.ClearAllPoints = function() end
		of:SetPoint(LolzenUIcfg["objectivetracker_anchor"], UIParent, LolzenUIcfg["objectivetracker_anchor"], LolzenUIcfg["objectivetracker_posx"], LolzenUIcfg["objectivetracker_posy"])
		of.SetPoint = function() end
		of:SetHeight(650)
		if LolzenUIcfg["objectivetracker_logincollapse"] == true then
			ObjectiveTracker_Collapse()
		end
		-- bring the HM aesthetically in line with the button, wherever the ObjectiveTrackerFrame's position is set
		of.HeaderMenu.Title:SetPoint("TOPLEFT", of, "TOPLEFT", -170, -5)
	end
end)

local f2 = CreateFrame("Frame")
f2:RegisterEvent("PLAYER_REGEN_DISABLED")
f2:RegisterEvent("PLAYER_REGEN_ENABLED")
f2:SetScript("OnEvent", function(self, event, addon)
	if event == "PLAYER_REGEN_DISABLED" then
		if LolzenUIcfg["objectivetracker_combatcollapse"] == false then return end
		ObjectiveTracker_Collapse()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if LolzenUIcfg["objectivetracker_combatcollapse"] == false then return end
		local of = ObjectiveTrackerFrame
		if of.collapsed and not InCombatLockdown() then
			ObjectiveTracker_Expand()
		end
	end
end)