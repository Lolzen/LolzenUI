--// options for orderhallbar //--

local addon, ns = ...

ns.RegisterModule("orderhallbar")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["orderhallbar"] == true then

		local title = ns.createTitle("orderhallbar")

		local about = ns.createDescription("orderhallbar", "Modify the OrderHallBar and show currencies marked as \"Show in Backpack\"")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local cb1 = ns.createCheckBox("orderhallbar", "alwaysshow", "|cff5599ffalways show the orderhallbar|r", LolzenUIcfg.orderhallbar["ohb_always_show"])
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local header1 = ns.createHeader("orderhallbar", "Background:")
		header1:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, -30)
		
		local ohb_bg_text = ns.createFonstring("orderhallbar", "Texture:")
		ohb_bg_text:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, -8)

		local ohb_bg = ns.createInputbox("orderhallbar", 80, 20, LolzenUIcfg.orderhallbar["ohb_background"])
		ohb_bg:SetPoint("LEFT", ohb_bg_text, "RIGHT", 10, 0)

		local color_text = ns.createFonstring("orderhallbar", "Color:")
		color_text:SetPoint("LEFT", ohb_bg, "RIGHT", 10, 0)

		local color = ns.createColorTexture("orderhallbar", 16, 16, LolzenUIcfg.orderhallbar["ohb_background_color"], LolzenUIcfg.orderhallbar["ohb_background"])
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)

		local color_f = ns.createColorPicker("orderhallbar", color, LolzenUIcfg.orderhallbar["ohb_background_color"])
		color_f:SetAllPoints(color)

		local alpha_text = ns.createFonstring("orderhallbar", "Alpha:")
		alpha_text:SetPoint("LEFT", color, "RIGHT", 10, 0)

		local alpha = ns.createInputbox("orderhallbar", 30, 20, LolzenUIcfg.orderhallbar["ohb_background_alpha"])
		alpha:SetPoint("LEFT", alpha_text, "RIGHT", 10, 0)

		local header2 = ns.createHeader("orderhallbar", "Zonetext:")
		header2:SetPoint("TOPLEFT", ohb_bg_text, "BOTTOMLEFT", 0, -30)

		local zone_color_text = ns.createFonstring("orderhallbar", "Color:")
		zone_color_text:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, -8)

		local zone_color = ns.createColorTexture("orderhallbar", 16, 16, LolzenUIcfg.orderhallbar["ohb_zone_color"], LolzenUIcfg.orderhallbar["ohb_background"])
		zone_color:SetPoint("LEFT", zone_color_text, "RIGHT", 10, 0)

		local zone_color_f = ns.createColorPicker("orderhallbar", zone_color, LolzenUIcfg.orderhallbar["ohb_zone_color"])
		zone_color_f:SetAllPoints(zone_color)

		local header3 = ns.createHeader("orderhallbar", "Currency:")
		header3:SetPoint("TOPLEFT", zone_color_text, "BOTTOMLEFT", 0, -30)

		local font_text = ns.createFonstring("orderhallbar", "Font:")
		font_text:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, -8)

		local font = ns.createPicker("orderhallbar", "font", "orderhallbar_font", 120, LolzenUIcfg.orderhallbar["ohb_currency_font"])
		font:SetPoint("LEFT", font_text, "RIGHT", -10, -3)

		local font_size_text = ns.createFonstring("orderhallbar", "Size:")
		font_size_text:SetPoint("LEFT", font, "RIGHT", -5, 3)

		local font_size = ns.createInputbox("orderhallbar", 30, 20, LolzenUIcfg.orderhallbar["ohb_currency_font_size"])
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)

		local font_flag_text = ns.createFonstring("orderhallbar", "Flag:")
		font_flag_text:SetPoint("LEFT", font_size, "RIGHT", 10, 0)

		local font_flag = ns.createPicker("orderhallbar", "flag", "orderhallbar_font_flag", 120, LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", -10, -3)

		local icon_size_text = ns.createFonstring("orderhallbar", "Icon Size:")
		icon_size_text:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -15)

		local icon_size = ns.createInputbox("orderhallbar", 30, 20, LolzenUIcfg.orderhallbar["ohb_currency_icon_size"])
		icon_size:SetPoint("LEFT", icon_size_text, "RIGHT", 10, 0)

		ns["orderhallbar"].okay = function(self)
			LolzenUIcfg.orderhallbar["ohb_currency_icon_size"] = tonumber(icon_size:GetText())
			LolzenUIcfg.orderhallbar["ohb_currency_font"] = ns.picker_fonts[UIDropDownMenu_GetSelectedID(font)]
			LolzenUIcfg.orderhallbar["ohb_currency_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.orderhallbar["ohb_currency_font_flag"] = ns.picker_flags[UIDropDownMenu_GetSelectedID(font_flag)]
			LolzenUIcfg.orderhallbar["ohb_zone_color"] = {zone_color:GetVertexColor()}
			LolzenUIcfg.orderhallbar["ohb_background"] = ohb_bg:GetText()
			LolzenUIcfg.orderhallbar["ohb_background_color"] = {color:GetVertexColor()}
			LolzenUIcfg.orderhallbar["ohb_background_alpha"] = tonumber(alpha:GetText())
			LolzenUIcfg.orderhallbar["ohb_always_show"] = cb1:GetChecked()
		end

		ns["orderhallbar"].default = function(self)
			LolzenUIcfg.orderhallbar["ohb_currency_icon_size"] = 18
			LolzenUIcfg.orderhallbar["ohb_currency_font"] = "DroidSansBold.ttf"
			LolzenUIcfg.orderhallbar["ohb_currency_font_size"] = 12
			LolzenUIcfg.orderhallbar["ohb_currency_font_flag"] = "OUTLINE"
			LolzenUIcfg.orderhallbar["ohb_zone_color"] = {51/255, 181/255, 229/225}
			LolzenUIcfg.orderhallbar["ohb_background"] = "statusbar"
			LolzenUIcfg.orderhallbar["ohb_background_color"] = {0, 0, 0}
			LolzenUIcfg.orderhallbar["ohb_background_alpha"] = 0.5
			LolzenUIcfg.orderhallbar["ohb_always_show"] = true
			ReloadUI()
		end
	end
end)