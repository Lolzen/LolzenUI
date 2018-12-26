--// objectivetracker // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("objectivetracker", L["desc_objectivetracker"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "LolzenUI" then
		if LolzenUIcfg.modules["objectivetracker"] == false then return end

		local of = ObjectiveTrackerFrame

		of:ClearAllPoints()
		of.ClearAllPoints = function() end
		of:SetPoint(LolzenUIcfg.objectivetracker["objectivetracker_anchor"], UIParent, LolzenUIcfg.objectivetracker["objectivetracker_anchor"], LolzenUIcfg.objectivetracker["objectivetracker_posx"], LolzenUIcfg.objectivetracker["objectivetracker_posy"])
		of.SetPoint = function() end
		of:SetHeight(650)
		of:SetScale(LolzenUIcfg.objectivetracker["objectivetracker_scale"])
		if LolzenUIcfg.objectivetracker["objectivetracker_logincollapse"] == true then
			ObjectiveTracker_Collapse()
		end
		-- bring the HM aesthetically in line with the button, wherever the ObjectiveTrackerFrame's position is set
		of.HeaderMenu.Title:SetPoint("TOPLEFT", of, "TOPLEFT", -170, -5)
	elseif event == "PLAYER_REGEN_DISABLED" then
		if LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] == false then return end
		ObjectiveTracker_Collapse()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] == false then return end
		local of = ObjectiveTrackerFrame
		if of.collapsed and not InCombatLockdown() then
			ObjectiveTracker_Expand()
		end
	end
end)