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
		about:SetText("Show the OrderHallBar everywhere. Also modify it")

--		local notice = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
--		notice:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
--		notice:SetText("|cff5599ffTO BE DONE|r")

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
		
		local list = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		list:SetPoint("TOPLEFT", icon_size_text, "BOTTOMLEFT", 0, -20)
		list:SetText("|cff5599ffCurrencies which are being displayed:|r")

		local function getInfo(id)
			local name, _, icon = GetCurrencyInfo(id)
			if icon ~= nil then
				return name, icon
			else
				return GetSpellInfo(212812), select(3, GetSpellInfo(212812))
			end
		end
		
		local icon = {}
		for i=1, #LolzenUIcfg.orderhallbar["ohb_currencies"] do
			icon[i] = ns["orderhallbar"]:CreateTexture(nil, "OVERLAY")
			icon[i]:SetTexCoord(.04, .94, .04, .94)
			icon[i]:SetTexture(select(2, getInfo(LolzenUIcfg.orderhallbar["ohb_currencies"][i])))
			icon[i]:SetSize(26, 26)
			if i == 1 then
				icon[i]:SetPoint("TOPLEFT", list, "BOTTOMLEFT", 0, -20)
			else
				icon[i]:SetPoint("TOPLEFT", icon[i-1], "BOTTOMLEFT", 0, -5)
			end
			if not icon[i].text then
				icon[i].text = ns["orderhallbar"]:CreateFontString(nil, "OVERLAY")
				icon[i].text:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf", 12 ,"OUTLINE")
				icon[i].text:SetTextColor(1, 1, 1)
				icon[i].text:SetPoint("LEFT", icon[i], "RIGHT", 10, 0)
				icon[i].text:SetText(getInfo(LolzenUIcfg.orderhallbar["ohb_currencies"][i]).." (currencyid: "..LolzenUIcfg.orderhallbar["ohb_currencies"][i]..")")
			end
		end
		
		local add = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		add:SetPoint("LEFT", list, "RIGHT", 110, 0)
		add:SetText("|cffffffffadd or delete currencies to be displayed (per currencyid):|r")
		
		local eb = CreateFrame("EditBox", nil, ns["orderhallbar"], "InputBoxTemplate")
		eb:SetPoint("TOPLEFT", add, "BOTTOMLEFT", 5, -8)
		eb:SetSize(50, 20)
		eb:SetAutoFocus(false)
		eb:ClearFocus()
		eb:SetCursorPosition(0)
		
		local previewicon = ns["orderhallbar"]:CreateTexture(nil, "OVERLAY")
		previewicon:SetTexCoord(.04, .94, .04, .94)
		previewicon:SetTexture(select(3, GetSpellInfo(212812)))
		previewicon:SetSize(16, 16)
		previewicon:SetPoint("LEFT", eb, "RIGHT", 5, 0)

		local prevname = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		prevname:SetPoint("LEFT", previewicon, "RIGHT", 5, 0)
		prevname:SetText(GetSpellInfo(212812))
		
		eb:SetScript("OnTextChanged", function(self)
			previewicon:SetTexture(select(2, getInfo(eb:GetText())))
			prevname:SetText(getInfo(eb:GetText()))
		end)
		
		local b = CreateFrame("Button", "addButton", ns["orderhallbar"], "UIPanelButtonTemplate")
		b:SetSize(80 ,22)
		b:SetText("add")
		b:SetPoint("TOPLEFT", eb, "BOTTOMLEFT", -7, -8)
		b:SetScript("OnClick", function()
			local isduplicate = false
			for k, v in pairs(LolzenUIcfg.orderhallbar["ohb_currencies"]) do
				if v == eb:GetText() then
					isduplicate = true
				end
			end
			if isduplicate == true then
				print("duplicate id detected!")
			else
				table.insert(LolzenUIcfg.orderhallbar["ohb_currencies"], eb:GetText())
				print("Hit Okay reload the list")
			end
		end)
		
		local b2 = CreateFrame("Button", "delButton", ns["orderhallbar"], "UIPanelButtonTemplate")
		b2:SetSize(80 ,22) -- width, height
		b2:SetText("delete")
		b2:SetPoint("LEFT", b, "RIGHT", 10, 0)
		b2:SetScript("OnClick", function()
			for k, v in pairs(LolzenUIcfg.orderhallbar["ohb_currencies"]) do
				if v == eb:GetText() then
					table.remove(LolzenUIcfg.orderhallbar["ohb_currencies"], k)
				end
			end
			print("Hit Okay to reload the list")
		end)
		
		local tip = ns["orderhallbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		tip:SetPoint("TOPLEFT", b, "BOTTOMLEFT", 0, -8)
		tip:SetText("|cff5599ffPROTIP: |rrefer to WoWhead and search for your currency,\n the currencyid is in the URL")
		
		local help = ns["orderhallbar"]:CreateTexture(nil, "OVERLAY")
		help:SetSize(268, 60)
		help:SetTexture("Interface\\AddOns\\LolzenUI\\modules\\orderhallbar\\help.tga")
		help:SetPoint("TOPLEFT", tip, "BOTTOMLEFT", 0, -8)
		
		ns["orderhallbar"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg.orderhallbar["ohb_always_show"] = true
			else
				LolzenUIcfg.orderhallbar["ohb_always_show"] = false
			end
		end

		ns["orderhallbar"].default = function(self)
			LolzenUIcfg.orderhallbar["ohb_always_show"] = true
			ReloadUI()
		end
	end
end)