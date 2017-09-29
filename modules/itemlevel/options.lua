--// options for itemlevel //--

local addon, ns = ...

ns.RegisterModule("itemlevel")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["itemlevel"] == true then

		local title = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["itemlevel"], 16, -16)
		title:SetText("|cff5599ff"..ns["itemlevel"].name.."|r")

		local about = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Displays item level on items")

		local cb1 = CreateFrame("CheckButton", "Character", ns["itemlevel"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		CharacterText:SetText("|cff5599ffShow Itemlevel on Character frame|r")

		if LolzenUIcfg.itemlevel["ilvl_characterframe"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		local cb2 = CreateFrame("CheckButton", "Inspect", ns["itemlevel"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		InspectText:SetText("|cff5599ffShow Itemlevel on Inspect frame|r")

		if LolzenUIcfg.itemlevel["ilvl_inspectframe"] == true then
			cb2:SetChecked(true)
		else
			cb2:SetChecked(false)
		end

		local text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		text:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, -8)
		text:SetText("|cff5599ffiLvL text:|r")

		local pos_x_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", text, "BOTTOMLEFT", 0, -10)
		pos_x_text:SetText("PosX:")

		local pos_x = CreateFrame("EditBox", nil, ns["itemlevel"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 20)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg.itemlevel["ilvl_font_posx"])
		pos_x:SetCursorPosition(0)

		local pos_y_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("PosY:")

		local pos_y = CreateFrame("EditBox", nil, ns["itemlevel"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 20)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg.itemlevel["ilvl_font_posy"])
		pos_y:SetCursorPosition(0)

		local anchor_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)
		anchor_text:SetText("Anchor:")

		local anchor = CreateFrame("EditBox", nil, ns["itemlevel"], "InputBoxTemplate")
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", 10, 0)
		anchor:SetSize(100, 20)
		anchor:SetAutoFocus(false)
		anchor:ClearFocus()
		anchor:SetText(LolzenUIcfg.itemlevel["ilvl_anchor"])
		anchor:SetCursorPosition(0)

		local color_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text:SetPoint("LEFT", anchor, "RIGHT", 10, 0)
		color_text:SetText("Font color:")

		local color = ns["itemlevel"]:CreateTexture(nil, "ARTWORK")
		color:SetSize(16, 16)
		color:SetVertexColor(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)
		color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f = CreateFrame("Frame", nil, ns["itemlevel"])
		color_f:SetFrameStrata("HIGH")
		color_f:EnableMouse(true)
		color_f:SetAllPoints(color)
		color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg.itemlevel["ilvl_font_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg.itemlevel["ilvl_font_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local font_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_text:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -8)
		font_text:SetText("|cff5599ffFont:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local font = CreateFrame("EditBox", nil, ns["itemlevel"], "InputBoxTemplate")
		font:SetPoint("LEFT", font_text, "RIGHT", 10, 0)
		font:SetSize(120, 20)
		font:SetAutoFocus(false)
		font:ClearFocus()
		font:SetText(LolzenUIcfg.itemlevel["ilvl_font"])
		font:SetCursorPosition(0)

		local font_size_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_size_text:SetPoint("LEFT", font, "RIGHT", 5, 0)
		font_size_text:SetText("Size:")

		local font_size = CreateFrame("EditBox", nil, ns["itemlevel"], "InputBoxTemplate")
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)
		font_size:SetSize(30, 20)
		font_size:SetAutoFocus(false)
		font_size:ClearFocus()
		font_size:SetNumber(LolzenUIcfg.itemlevel["ilvl_font_size"])
		font_size:SetCursorPosition(0)

		local font_flag_text = ns["itemlevel"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_flag_text:SetPoint("LEFT", font_size, "RIGHT", 5, 0)
		font_flag_text:SetText("Flag:")

		local font_flag = CreateFrame("EditBox", nil, ns["itemlevel"], "InputBoxTemplate")
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", 10, 0)
		font_flag:SetSize(100, 20)
		font_flag:SetAutoFocus(false)
		font_flag:ClearFocus()
		font_flag:SetText(LolzenUIcfg.itemlevel["ilvl_font_flag"])
		font_flag:SetCursorPosition(0)

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
			LolzenUIcfg.itemlevel["ilvl_anchor"] = anchor:GetText()
			LolzenUIcfg.itemlevel["ilvl_font_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg.itemlevel["ilvl_font_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg.itemlevel["ilvl_font_color"] = {color:GetVertexColor()}
			LolzenUIcfg.itemlevel["ilvl_font"] = font:GetText()
			LolzenUIcfg.itemlevel["ilvl_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.itemlevel["ilvl_font_flag"] = font_flag:GetText()
		end

		ns["itemlevel"].default = function(self)
			LolzenUIcfg.itemlevel["ilvl_characterframe"] = true
			LolzenUIcfg.itemlevel["ilvl_inspectframe"] = true
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