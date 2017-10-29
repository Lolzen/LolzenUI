--// options for itemlevel //--

local addon, ns = ...

ns.RegisterModule("itemlevel")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["itemlevel"] == true then

		local title = ns.createTitle("itemlevel")

		local about = ns.createDescription("itemlevel", "Displays item level on equippable items")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local cb1 = ns.createCheckBox("itemlevel", "Character", "|cff5599ffShow Itemlevel on Character frame|r", LolzenUIcfg.itemlevel["ilvl_characterframe"])
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local cb2 = ns.createCheckBox("itemlevel", "Inspect", "|cff5599ffShow Itemlevel on Inspect frame|r", LolzenUIcfg.itemlevel["ilvl_inspectframe"])
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)

		local cb3 = ns.createCheckBox("itemlevel", "Bags", "|cff5599ffShow Itemlevel in Bags|r", LolzenUIcfg.itemlevel["ilvl_bags"])
		cb3:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, 0)

		local header = ns.createHeader("itemlevel", "iLvL text:")
		header:SetPoint("TOPLEFT", cb3, "BOTTOMLEFT", 0, -13)

		local pos_x_text = ns.createFonstring("itemlevel", "PosX:")
		pos_x_text:SetPoint("TOPLEFT", header, "BOTTOMLEFT", 0, -10)

		local pos_x = ns.createInputbox("itemlevel", 30, 20, LolzenUIcfg.itemlevel["ilvl_font_posx"])
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)

		local pos_y_text = ns.createFonstring("itemlevel", "PosY:")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)

		local pos_y = ns.createInputbox("itemlevel", 30, 20, LolzenUIcfg.itemlevel["ilvl_font_posy"])
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)

		local anchor_text = ns.createFonstring("itemlevel", "Anchor:")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)

		local anchor = ns.createPicker("itemlevel", "anchor", "ilvl_anchor_1", 110, LolzenUIcfg.itemlevel["ilvl_anchor"])
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", -10, -3)

		local color_text = ns.createFonstring("itemlevel", "Font color:")
		color_text:SetPoint("LEFT", anchor, "RIGHT", -5, 3)

		local color = ns.createColorTexture("itemlevel", 16, 16, LolzenUIcfg.itemlevel["ilvl_font_color"], "statusbar")
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)

		local color_f = ns.createColorPicker("itemlevel", color, LolzenUIcfg.itemlevel["ilvl_font_color"])
		color_f:SetAllPoints(color)

		local font_text = ns.createFonstring("itemlevel", "Font:")
		font_text:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -15)

		local font = ns.createPicker("itemlevel", "font", "itemlevel_font", 120, LolzenUIcfg.itemlevel["ilvl_font"])
		font:SetPoint("LEFT", font_text, "RIGHT", -10, -3)

		local font_size_text = ns.createFonstring("itemlevel", "Size:")
		font_size_text:SetPoint("LEFT", font, "RIGHT", -5, 3)

		local font_size = ns.createInputbox("itemlevel", 30, 20, LolzenUIcfg.itemlevel["ilvl_font_size"])
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)

		local font_flag_text = ns.createFonstring("itemlevel", "Flag:")
		font_flag_text:SetPoint("LEFT", font_size, "RIGHT", 5, 0)

		local font_flag = ns.createPicker("itemlevel", "flag", "itemlevel_font_flag", 120, LolzenUIcfg.itemlevel["ilvl_font_flag"])
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", -10, -3)

		ns["itemlevel"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg.itemlevel["ilvl_characterframe"] = true
			else
				LolzenUIcfg.itemlevel["ilvl_characterframe"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg.itemlevel["ilvl_inspectframe"] = true
			else
				LolzenUIcfg.itemlevel["ilvl_inspectframe"] = false
			end
			if cb3:GetChecked(true) then
				LolzenUIcfg.itemlevel["ilvl_bags"] = true
			else
				LolzenUIcfg.itemlevel["ilvl_bags"] = false
			end
			LolzenUIcfg.itemlevel["ilvl_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(anchor)]
			LolzenUIcfg.itemlevel["ilvl_font_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg.itemlevel["ilvl_font_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg.itemlevel["ilvl_font_color"] = {color:GetVertexColor()}
			LolzenUIcfg.itemlevel["ilvl_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(font)]
			LolzenUIcfg.itemlevel["ilvl_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.itemlevel["ilvl_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(font_flag)]
		end

		ns["itemlevel"].default = function(self)
			LolzenUIcfg.itemlevel["ilvl_characterframe"] = true
			LolzenUIcfg.itemlevel["ilvl_inspectframe"] = true
			LolzenUIcfg.itemlevel["ilvl_bags"] = true
			LolzenUIcfg.itemlevel["ilvl_anchor"] = "TOP"
			LolzenUIcfg.itemlevel["ilvl_font_posx"] = 0
			LolzenUIcfg.itemlevel["ilvl_font_posy"] = -5
			LolzenUIcfg.itemlevel["ilvl_font_color"] = {0, 1, 0}
			LolzenUIcfg.itemlevel["ilvl_font"] = "DroidSans.ttf"
			LolzenUIcfg.itemlevel["ilvl_font_size"] = 14
			LolzenUIcfg.itemlevel["ilvl_font_flag"] = "THINOUTLINE"
			ReloadUI()
		end
	end
end)