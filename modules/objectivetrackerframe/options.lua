--// options for objectivetracker //--

local addon, ns = ...

ns.RegisterModule("objectivetracker")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["objectivetracker"] == true then

		local title = ns.createTitle("objectivetracker")

		local about = ns.createDescription("objectivetracker", "Modify behaviour and position of the ObjectiveTrackerFrame.")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local cb1 = ns.createCheckBox("objectivetracker", "combatcollapse", "|cff5599ffcombat auto collapse|r", LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"])
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local cb1_desc = ns.createFonstring("objectivetracker", "auto collapse infight and auto expand out of combat")
		cb1_desc:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)

		local cb2 = ns.createCheckBox("objectivetracker", "logincollapse", "|cff5599ffauto login collapse|r", LolzenUIcfg.objectivetracker["objectivetracker_logincollapse"])
		cb2:SetPoint("TOPLEFT", cb1_desc, "BOTTOMLEFT", 0, -8)

		local cb2_desc = ns.createFonstring("objectivetracker", "auto collapse on login")
		cb2_desc:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)

		local pos_x_text = ns.createFonstring("objectivetracker", "PosX:")
		pos_x_text:SetPoint("TOPLEFT", cb2_desc, "BOTTOMLEFT", 0, -20)

		local pos_x = ns.createInputbox("objectivetracker", 30, 20, LolzenUIcfg.objectivetracker["objectivetracker_posx"])
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)

		local pos_y_text = ns.createFonstring("objectivetracker", "PosY:")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)

		local pos_y = ns.createInputbox("objectivetracker", 30, 20, LolzenUIcfg.objectivetracker["objectivetracker_posy"])
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)

		local anchor_text = ns.createFonstring("objectivetracker", "Anchor:")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)

		local anchor = ns.createPicker("objectivetracker", "anchor", "objectivetracker_anchor", 110, LolzenUIcfg.objectivetracker["objectivetracker_anchor"])
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", -10, -3)

		ns["objectivetracker"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] = true
			else
				LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg.objectivetracker["objectivetracker_logincollapse"] = true
			else
				LolzenUIcfg.objectivetracker["objectivetracker_logincollapse"] = false
			end
			LolzenUIcfg.objectivetracker["objectivetracker_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg.objectivetracker["objectivetracker_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg.objectivetracker["objectivetracker_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(anchor)]
			LolzenUIcfg.objectivetracker["objectivetracker_scale"] = tonumber(anchor_point:GetText())
		end

		ns["objectivetracker"].default = function(self)
			LolzenUIcfg.objectivetracker["objectivetracker_combatcollapse"] = true
			LolzenUIcfg.objectivetracker["objectivetracker_logincollapse"] = true
			LolzenUIcfg.objectivetracker["objectivetracker_posx"] = 30
			LolzenUIcfg.objectivetracker["objectivetracker_posy"] = -30
			LolzenUIcfg.objectivetracker["objectivetracker_anchor"] = "TOPLEFT"
			LolzenUIcfg.objectivetracker["objectivetracker_scale"] = 1
			ReloadUI()
		end
	end
end)