--// options for orderhallbar //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "orderhallbar")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["orderhallbar"] == true then

		local title = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["orderhallbar"], 16, -16)
		title:SetText("|cff5599ff"..ns["orderhallbar"].name.."|r")

		local about = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Modify the OrderHallBar and show currencies marked as \"Show in Backpack\"")

		local cb1 = CreateFrame("CheckButton", "alwaysshow", ns["orderhallbar"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		alwaysshowText:SetText("|cff5599ffalways show the orderhallbar|r")

		if LolzenUIcfg.orderhallbar["ohb_always_show"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		local ohb_bg_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		ohb_bg_text:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, -8)
		ohb_bg_text:SetText("Backround:")

		local ohb_bg = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		ohb_bg:SetPoint("LEFT", ohb_bg_text, "RIGHT", 10, 0)
		ohb_bg:SetSize(80, 20)
		ohb_bg:SetAutoFocus(false)
		ohb_bg:ClearFocus()
		ohb_bg:SetText(LolzenUIcfg.orderhallbar["ohb_background"])
		ohb_bg:SetCursorPosition(0)

		local color_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text:SetPoint("LEFT", ohb_bg, "RIGHT", 10, 0)
		color_text:SetText("Background color:")

		local color = ns["orderhallbar"]:CreateTexture(nil, "ARTWORK")
		color:SetSize(16, 16)
		color:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)
		color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.orderhallbar["ohb_background"])

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f = CreateFrame("Frame", nil, ns["orderhallbar"])
		color_f:SetFrameStrata("HIGH")
		color_f:EnableMouse(true)
		color_f:SetAllPoints(color)
		color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg.orderhallbar["ohb_background_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg.orderhallbar["ohb_background_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local alpha_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		alpha_text:SetPoint("LEFT", color, "RIGHT", 10, 0)
		alpha_text:SetText("Alpha:")

		local alpha = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		alpha:SetPoint("LEFT", alpha_text, "RIGHT", 10, 0)
		alpha:SetSize(30, 20)
		alpha:SetAutoFocus(false)
		alpha:ClearFocus()
		alpha:SetText(LolzenUIcfg.orderhallbar["ohb_background_alpha"])
		alpha:SetCursorPosition(0)

		local zone_color_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		zone_color_text:SetPoint("TOPLEFT", ohb_bg_text, "BOTTOMLEFT", 0, -10)
		zone_color_text:SetText("Zonetext color:")

		local zone_color = ns["orderhallbar"]:CreateTexture(nil, "ARTWORK")
		zone_color:SetSize(16, 16)
		zone_color:SetVertexColor(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))
		zone_color:SetPoint("LEFT", zone_color_text, "RIGHT", 10, 0)
		zone_color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg.orderhallbar["ohb_background"])

		local function zone_afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			zone_color:SetVertexColor(r, g, b)
		end

		local function zone_restorePreviousColor()
			zone_color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local zone_color_f = CreateFrame("Frame", nil, ns["orderhallbar"])
		zone_color_f:SetFrameStrata("HIGH")
		zone_color_f:EnableMouse(true)
		zone_color_f:SetAllPoints(zone_color)
		zone_color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg.orderhallbar["ohb_zone_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg.orderhallbar["ohb_zone_color"]))
			ColorPickerFrame.cancelFunc = zone_restorePreviousColor
			ColorPickerFrame.func = zone_afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local currency_header = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		currency_header:SetPoint("TOPLEFT", zone_color_text, "BOTTOMLEFT", 0, -10)
		currency_header:SetText("|cff5599ffCurrency:|r")

		local font_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_text:SetPoint("TOPLEFT", currency_header, "BOTTOMLEFT", 0, -8)
		font_text:SetText("|cff5599ffFont:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local font = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		font:SetPoint("LEFT", font_text, "RIGHT", 10, 0)
		font:SetSize(120, 20)
		font:SetAutoFocus(false)
		font:ClearFocus()
		font:SetText(LolzenUIcfg.orderhallbar["ohb_currency_font"])
		font:SetCursorPosition(0)

		local font_size_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_size_text:SetPoint("LEFT", font, "RIGHT", 5, 0)
		font_size_text:SetText("Size:")

		local font_size = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)
		font_size:SetSize(30, 20)
		font_size:SetAutoFocus(false)
		font_size:ClearFocus()
		font_size:SetNumber(LolzenUIcfg.orderhallbar["ohb_currency_font_size"])
		font_size:SetCursorPosition(0)

		local font_flag_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_flag_text:SetPoint("LEFT", font_size, "RIGHT", 5, 0)
		font_flag_text:SetText("Flag:")

		local font_flag = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", 10, 0)
		font_flag:SetSize(100, 20)
		font_flag:SetAutoFocus(false)
		font_flag:ClearFocus()
		font_flag:SetText(LolzenUIcfg.orderhallbar["ohb_currency_font_flag"])
		font_flag:SetCursorPosition(0)

		local icon_size_text = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		icon_size_text:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -8)
		icon_size_text:SetText("Icon size:")

		local icon_size = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		icon_size:SetPoint("LEFT", icon_size_text, "RIGHT", 10, 0)
		icon_size:SetSize(30, 20)
		icon_size:SetAutoFocus(false)
		icon_size:ClearFocus()
		icon_size:SetNumber(LolzenUIcfg.orderhallbar["ohb_currency_icon_size"])
		icon_size:SetCursorPosition(0)

		ns["orderhallbar"].okay = function(self)
			LolzenUIcfg.orderhallbar["ohb_currency_icon_size"] = tonumber(icon_size:GetText())
			LolzenUIcfg.orderhallbar["ohb_currency_font"] = font:GetText()
			LolzenUIcfg.orderhallbar["ohb_currency_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.orderhallbar["ohb_currency_font_flag"] = font_flag:GetText()
			LolzenUIcfg.orderhallbar["ohb_zone_color"] = {zone_color:GetVertexColor()}
			LolzenUIcfg.orderhallbar["ohb_background"] = ohb_bg:GetText()
			LolzenUIcfg.orderhallbar["ohb_background_color"] = {color:GetVertexColor()}
			LolzenUIcfg.orderhallbar["ohb_background_alpha"] = tonumber(alpha:GetText())
			if cb1:GetChecked(true) then
				LolzenUIcfg.orderhallbar["ohb_always_show"] = true
			else
				LolzenUIcfg.orderhallbar["ohb_always_show"] = false
			end
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