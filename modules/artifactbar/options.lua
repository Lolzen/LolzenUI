--// options for artifactbar //--

local addon, ns = ...

ns.RegisterModule("artifactbar")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["artifactbar"] == true then

		local title = ns.createTitle("artifactbar")

		local about = ns.createDescription("artifactbar", "A bar which shows artifact power progress")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local header1 = ns.createHeader("artifactbar", "Frame")
		header1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local height_text = ns.createFonstring("artifactbar", "Height:")
		height_text:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -8)

		local height = ns.createInputbox("artifactbar", 30, 20, LolzenUIcfg.artifactbar["artifactbar_height"])
		height:SetPoint("LEFT", height_text, "RIGHT", 10, 0)

		local width_text = ns.createFonstring("artifactbar", "Width:")
		width_text:SetPoint("LEFT", height, "RIGHT", 10, 0)

		local width = ns.createInputbox("artifactbar", 40, 20, LolzenUIcfg.artifactbar["artifactbar_width"])
		width:SetPoint("LEFT", width_text, "RIGHT", 10, 0)

		local alpha_text = ns.createFonstring("artifactbar", "Alpha:")
		alpha_text:SetPoint("LEFT", width, "RIGHT", 10, 0)

		local alpha = ns.createPicker("artifactbar", "alpha", "artifactbar_alpha", 45, LolzenUIcfg.artifactbar["artifactbar_alpha"])
		alpha:SetPoint("LEFT", alpha_text, "RIGHT", -10, -3)

		local bg_alpha_text = ns.createFonstring("artifactbar", "Background alpha:")
		bg_alpha_text:SetPoint("LEFT", alpha, "RIGHT", -5, 3)

		local bg_alpha = ns.createPicker("artifactbar", "alpha", "artifactbar_bg_alpha", 45, LolzenUIcfg.artifactbar["artifactbar_bg_alpha"])
		bg_alpha:SetPoint("LEFT", bg_alpha_text, "RIGHT", -10, -3)

		local pos_x_text = ns.createFonstring("artifactbar", "PosX:")
		pos_x_text:SetPoint("TOPLEFT", height_text, "BOTTOMLEFT", 0, -15)

		local pos_x = ns.createInputbox("artifactbar", 30, 20, LolzenUIcfg.artifactbar["artifactbar_posx"])
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)

		local pos_y_text = ns.createFonstring("artifactbar", "PosY:")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)

		local pos_y = ns.createInputbox("artifactbar", 30, 20, LolzenUIcfg.artifactbar["artifactbar_posy"])
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)

		local anchor_text = ns.createFonstring("artifactbar", "Anchor:")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)

		local anchor = ns.createPicker("artifactbar", "anchor", "artifactbar_anchor_bar", 110, LolzenUIcfg.artifactbar["artifactbar_anchor"])
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", -10, -3)

		local parent_text = ns.createFonstring("artifactbar", "Parent:")
		parent_text:SetPoint("LEFT", anchor, "RIGHT", -5, 3)

		local parent = ns.createInputbox("artifactbar", 100, 20, LolzenUIcfg.artifactbar["artifactbar_parent"])
		parent:SetPoint("LEFT", parent_text, "RIGHT", 10, 0)

		local texture_text = ns.createFonstring("artifactbar", "|cff5599ffTexture:|r Interface\\AddOns\\LolzenUI\\media\\")
		texture_text:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -15)

		local texture = ns.createInputbox("artifactbar", 100, 20, LolzenUIcfg.artifactbar["artifactbar_texture"])
		texture:SetPoint("LEFT", texture_text, "RIGHT", 10, 0)

		local color_text = ns.createFonstring("artifactbar", "Color:")
		color_text:SetPoint("TOPLEFT", texture_text, "BOTTOMLEFT", 0, -15)

		local color = ns.createColorTexture("artifactbar", 16, 16, LolzenUIcfg.artifactbar["artifactbar_color"], LolzenUIcfg.artifactbar["artifactbar_texture"])
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)

		local color_f = ns.createColorPicker("artifactbar", color, LolzenUIcfg.artifactbar["artifactbar_color"])
		color_f:SetAllPoints(color)

		local cb1 = CreateFrame("CheckButton", "pxborder", ns["artifactbar"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", color_text, "BOTTOMLEFT", 0, -8)
		pxborderText:SetText("|cff5599ffdraw a 1px border around the artifactbar|r")

		if LolzenUIcfg.artifactbar["artifactbar_1px_border"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		local cb2 = CreateFrame("CheckButton", "pxborder_round", ns["artifactbar"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		pxborder_roundText:SetText("|cff5599ffrounded 1px border|r")

		cb1:SetScript("OnClick", function(self)
			if cb1:GetChecked() == false then
				cb2:Disable()
				pxborder_roundText:SetText("|cff555555rounded 1px border|r |cffff5555enable 1px border for this option|r")
			else
				cb2:Enable()
				pxborder_roundText:SetText("|cff5599ffrounded 1px border|r")
			end
		end)

		if cb1:GetChecked() == false then
			cb2:Disable()
			pxborder_roundText:SetText("|cff555555rounded 1px border|r |cffff5555enable 1px border for this option|r")
		else
			if LolzenUIcfg.artifactbar["artifactbar_1px_border_round"] == true then
				cb2:SetChecked(true)
			else
				cb2:SetChecked(false)
			end
		end

		local header2 = ns.createHeader("artifactbar", "Font")
		header2:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, -30)

		local font_text = ns.createFonstring("artifactbar", "Font:")
		font_text:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, -10)

		local font = ns.createPicker("artifactbar", "font", "artifactbar_font", 120, LolzenUIcfg.artifactbar["artifactbar_font"])
		font:SetPoint("LEFT", font_text, "RIGHT", -10, -3)

		local font_size_text = ns.createFonstring("artifactbar", "Font size:")
		font_size_text:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -15)

		local font_size = ns.createInputbox("artifactbar", 30, 20, LolzenUIcfg.artifactbar["artifactbar_font_size"])
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)

		local font_flag_text = ns.createFonstring("artifactbar", "Font flag:")
		font_flag_text:SetPoint("TOPLEFT", font_size_text, "BOTTOMLEFT", 0, -15)

		local font_flag = ns.createPicker("artifactbar", "flag", "artifactbar_font_flag", 120, LolzenUIcfg.artifactbar["artifactbar_font_flag"])
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", -10, -3)

		local font_color_text = ns.createFonstring("artifactbar", "Font color:")
		font_color_text:SetPoint("TOPLEFT", font_flag_text, "BOTTOMLEFT", 0, -15)

		local text_color = ns.createColorTexture("artifactbar", 16, 16, LolzenUIcfg.artifactbar["artifactbar_font_color"], LolzenUIcfg.artifactbar["artifactbar_texture"])
		text_color:SetPoint("LEFT", font_color_text, "RIGHT", 10, 0)

		local text_color_f = ns.createColorPicker("artifactbar", text_color, LolzenUIcfg.artifactbar["artifactbar_font_color"])
		text_color_f:SetAllPoints(text_color)

		local text_pos_x_text = ns.createFonstring("artifactbar", "Text PosX:")
		text_pos_x_text:SetPoint("TOPLEFT", font_color_text, "BOTTOMLEFT", 0, -15)

		local text_pos_x = ns.createInputbox("artifactbar", 30, 20, LolzenUIcfg.artifactbar["artifactbar_text_posx"])
		text_pos_x:SetPoint("LEFT", text_pos_x_text, "RIGHT", 10, 0)

		local text_pos_y_text = ns.createFonstring("artifactbar", "Text PosY:")
		text_pos_y_text:SetPoint("LEFT", text_pos_x, "RIGHT", 5, 0)

		local text_pos_y = ns.createInputbox("artifactbar", 30, 20, LolzenUIcfg.artifactbar["artifactbar_text_posy"])
		text_pos_y:SetPoint("LEFT", text_pos_y_text, "RIGHT", 10, 0)

		local text_anchor_text = ns.createFonstring("artifactbar", "Text Anchor:")
		text_anchor_text:SetPoint("LEFT", text_pos_y, "RIGHT", 10, 0)

		local text_anchor = ns.createPicker("artifactbar", "anchor", "artifactbar_text_anchor_1", 110, LolzenUIcfg.artifactbar["artifactbar_text_anchor1"])
		text_anchor:SetPoint("LEFT", text_anchor_text, "RIGHT", -10, -3)

		ns["artifactbar"].okay = function(self)
			LolzenUIcfg.artifactbar["artifactbar_height"] = tonumber(height:GetText())
			LolzenUIcfg.artifactbar["artifactbar_width"] = tonumber(width:GetText())
			LolzenUIcfg.artifactbar["artifactbar_anchor"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(anchor)]
			LolzenUIcfg.artifactbar["artifactbar_parent"] = parent:GetText()
			LolzenUIcfg.artifactbar["artifactbar_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg.artifactbar["artifactbar_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg.artifactbar["artifactbar_texture"] = texture:GetText()
			LolzenUIcfg.artifactbar["artifactbar_alpha"] = tonumber(ns.picker_alpha[UIDropDownMenu_GetSelectedID(alpha)])
			LolzenUIcfg.artifactbar["artifactbar_bg_alpha"] = tonumber(ns.picker_alpha[UIDropDownMenu_GetSelectedID(bg_alpha)])
			LolzenUIcfg.artifactbar["artifactbar_color"] = {color:GetVertexColor()}
			if cb1:GetChecked(true) then
				LolzenUIcfg.artifactbar["artifactbar_1px_border"] = true
			else
				LolzenUIcfg.artifactbar["artifactbar_1px_border"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg.artifactbar["artifactbar_1px_border_round"] = true
			else
				LolzenUIcfg.artifactbar["artifactbar_1px_border_round"] = false
			end
			LolzenUIcfg.artifactbar["artifactbar_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(font)]
			LolzenUIcfg.artifactbar["artifactbar_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.artifactbar["artifactbar_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(font_flag)]
			LolzenUIcfg.artifactbar["artifactbar_font_color"] = {text_color:GetVertexColor()}
			LolzenUIcfg.artifactbar["artifactbar_text_posx"] = tonumber(text_pos_x:GetText())
			LolzenUIcfg.artifactbar["artifactbar_text_posy"] = tonumber(text_pos_y:GetText())
			LolzenUIcfg.artifactbar["artifactbar_text_anchor1"] = ns.picker_anchor[UIDropDownMenu_GetSelectedID(text_anchor)]
		end

		ns["artifactbar"].default = function(self)
			LolzenUIcfg.artifactbar["artifactbar_height"] = 4
			LolzenUIcfg.artifactbar["artifactbar_width"] = 378
			LolzenUIcfg.artifactbar["artifactbar_anchor"] = "BOTTOM"
			LolzenUIcfg.artifactbar["artifactbar_parent"] = "UIParent"
			LolzenUIcfg.artifactbar["artifactbar_posx"] = 0
			LolzenUIcfg.artifactbar["artifactbar_posy"] = 120
			LolzenUIcfg.artifactbar["artifactbar_texture"] = "statusbar"
			LolzenUIcfg.artifactbar["artifactbar_alpha"] = 0.4
			LolzenUIcfg.artifactbar["artifactbar_bg_alpha"] = 0.5
			LolzenUIcfg.artifactbar["artifactbar_color"] = {1, 1, 0.7}
			LolzenUIcfg.artifactbar["artifactbar_1px_border"] = true
			LolzenUIcfg.artifactbar["artifactbar_1px_border_round"] = true
			LolzenUIcfg.artifactbar["artifactbar_font"] = "DroidSansBold.ttf"
			LolzenUIcfg.artifactbar["artifactbar_font_size"] = 10
			LolzenUIcfg.artifactbar["artifactbar_font_flag"] = "THINOUTLINE"
			LolzenUIcfg.artifactbar["artifactbar_font_color"] = {1, 1, 1}
			LolzenUIcfg.artifactbar["artifactbar_text_posx"] = 0
			LolzenUIcfg.artifactbar["artifactbar_text_posy"] = 8
			LolzenUIcfg.artifactbar["artifactbar_text_anchor1"] = "TOP"
			ReloadUI()
		end
	end
end)