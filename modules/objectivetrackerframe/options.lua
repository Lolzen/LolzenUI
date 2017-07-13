--// options for objectivetracker //--

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["objectivetracker"] == true then

		local title = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["objectivetracker"], 16, -16)
		title:SetText("|cff5599ff"..ns["objectivetracker"].name.."|r")

		local about = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Modify behaviour and position of the ObjectiveTrackerFrame.")

		local cb1 = CreateFrame("CheckButton", "combatcollapse", ns["objectivetracker"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		combatcollapseText:SetText("|cff5599ffcombat auto collapse|r")

		if LolzenUIcfg["objectivetracker_combatcollapse"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		cb1_desc = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		cb1_desc:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		cb1_desc:SetText("|cffffffffauto collapse infight and auto expand out of combat|r")
		
		local cb2 = CreateFrame("CheckButton", "logincollapse", ns["objectivetracker"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1_desc, "BOTTOMLEFT", 0, -8)
		logincollapseText:SetText("|cff5599ffauto login collapse|r")

		if LolzenUIcfg["objectivetracker_logincollapse"] == true then
			cb2:SetChecked(true)
		else
			cb2:SetChecked(false)
		end

		cb2_desc = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		cb2_desc:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)
		cb2_desc:SetText("|cffffffffauto collapse on login|r")

		local pos_x_text = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", cb2_desc, "BOTTOMLEFT", 0, -20)
		pos_x_text:SetText("|cffffffffPosX:")

		local pos_x = CreateFrame("EditBox", nil, ns["objectivetracker"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 50)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg["objectivetracker_posx"])
		pos_x:SetCursorPosition(0)

		local pos_y_text = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("|cffffffffPosX:")

		local pos_y = CreateFrame("EditBox", nil, ns["objectivetracker"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 50)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg["objectivetracker_posy"])
		pos_y:SetCursorPosition(0)

		local anchor_text = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)
		anchor_text:SetText("|cffffffffAnchor:")

		local anchor_point = CreateFrame("EditBox", nil, ns["objectivetracker"], "InputBoxTemplate")
		anchor_point:SetPoint("LEFT", anchor_text, "RIGHT", 10, 0)
		anchor_point:SetSize(100, 50)
		anchor_point:SetAutoFocus(false)
		anchor_point:ClearFocus()
		anchor_point:SetText(LolzenUIcfg["objectivetracker_anchor"])
		anchor_point:SetCursorPosition(0)

		local pos_desc = ns["objectivetracker"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_desc:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -8)
		pos_desc:SetText("|cffffffffThe startingpoint is the anchor set ("..LolzenUIcfg["objectivetracker_anchor"].." 0/0)")

		ns["objectivetracker"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg["objectivetracker_combatcollapse"] = true
			else
				LolzenUIcfg["objectivetracker_combatcollapse"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg["objectivetracker_logincollapse"] = true
			else
				LolzenUIcfg["objectivetracker_logincollapse"] = false
			end
			LolzenUIcfg["objectivetracker_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg["objectivetracker_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg["objectivetracker_anchor"] = anchor_point:GetText()
			LolzenUIcfg["objectivetracker_scale"] = tonumber(anchor_point:GetText())
		end

		ns["objectivetracker"].default = function(self)
			LolzenUIcfg["objectivetracker_combatcollapse"] = true
			LolzenUIcfg["objectivetracker_logincollapse"] = true
			LolzenUIcfg["objectivetracker_posx"] = 30
			LolzenUIcfg["objectivetracker_posy"] = -30
			LolzenUIcfg["objectivetracker_anchor"] = "TOPLEFT"
			LolzenUIcfg["objectivetracker_scale"] = 1
			ReloadUI()
		end
	end
end)