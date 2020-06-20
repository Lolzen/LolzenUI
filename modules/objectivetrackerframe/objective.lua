--// objectivetracker // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("objectivetracker", L["desc_objectivetracker"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:RegisterEvent("PLAYER_REGEN_DISABLED")
f:RegisterEvent("PLAYER_REGEN_ENABLED")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:SetScript("OnEvent", function(self, event, addon)
	if event == "ADDON_LOADED" and addon == "LolzenUI" then
		if LolzenUIcfg.modules["objectivetracker"] == false then return end

		local of_fake = CreateFrame("Frame", nil, UIParent)
		of_fake:SetHeight(650)
		of_fake:SetWidth(200)
		local of = ObjectiveTrackerFrame
		of:ClearAllPoints()
		of.ClearAllPoints = function() end
		of:SetPoint("TOPLEFT", of_fake, "TOPLEFT")
		of.SetPoint = function() end
		of_fake:SetPoint(LolzenUIcfg.objectivetracker["objectivetracker_anchor"], UIParent, LolzenUIcfg.objectivetracker["objectivetracker_anchor"], LolzenUIcfg.objectivetracker["objectivetracker_posx"], LolzenUIcfg.objectivetracker["objectivetracker_posy"])
		of:SetHeight(650)
		of:SetScale(LolzenUIcfg.objectivetracker["objectivetracker_scale"])
		if LolzenUIcfg.objectivetracker["objectivetracker_logincollapse"] == true then
			ObjectiveTracker_Collapse()
		end
		-- bring the HM aesthetically in line with the button, wherever the ObjectiveTrackerFrame's position is set
		of.HeaderMenu.Title:SetPoint("TOPLEFT", of, "TOPLEFT", -170, -5)

		ns.setOTPos = function()
			of_fake:ClearAllPoints()
			of_fake:SetPoint(LolzenUIcfg.objectivetracker["objectivetracker_anchor"], UIParent, LolzenUIcfg.objectivetracker["objectivetracker_anchor"], LolzenUIcfg.objectivetracker["objectivetracker_posx"], LolzenUIcfg.objectivetracker["objectivetracker_posy"])
		end

		ns.setOTScale = function()
			of:SetScale(LolzenUIcfg.objectivetracker["objectivetracker_scale"])
		end
	elseif event == "PLAYER_REGEN_DISABLED" then
		if LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] == false then return end
		ObjectiveTracker_Collapse()
	elseif event == "PLAYER_REGEN_ENABLED" then
		if LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] == false then return end
		if LolzenUIcfg.objectivetracker["objectivetracker_dungeoncollapse"] == true and IsInInstance() then return end
		local of = ObjectiveTrackerFrame
		if of.collapsed and not InCombatLockdown() then
			ObjectiveTracker_Expand()
		end
	elseif event == "PLAYER_ENTERING_WORLD" then
		if LolzenUIcfg.objectivetracker["objectivetracker_dungeoncollapse"] == false then return end
		if IsInInstance() then
			ObjectiveTracker_Collapse()
		end
	end
end)