--// options for artifactbar //--

local addon, ns = ...

--// options for artifactbar //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "artifactbar")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["artifactbar"] == true then

		local title = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["artifactbar"], 16, -16)
		title:SetText("|cff5599ff"..ns["artifactbar"].name.."|r")

		local about = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("A bar which shows artifact power progress")

		local height_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		height_text:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		height_text:SetText("Height:")

		local height = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		height:SetPoint("LEFT", height_text, "RIGHT", 10, 0)
		height:SetSize(30, 20)
		height:SetAutoFocus(false)
		height:ClearFocus()
		height:SetNumber(LolzenUIcfg["artifactbar_height"])
		height:SetCursorPosition(0)

		local width_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		width_text:SetPoint("LEFT", height, "RIGHT", 10, 0)
		width_text:SetText("Width:")

		local width = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		width:SetPoint("LEFT", width_text, "RIGHT", 10, 0)
		width:SetSize(40, 20)
		width:SetAutoFocus(false)
		width:ClearFocus()
		width:SetNumber(LolzenUIcfg["artifactbar_width"])
		width:SetCursorPosition(0)

		local alpha_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		alpha_text:SetPoint("LEFT", width, "RIGHT", 10, 0)
		alpha_text:SetText("Alpha:")

		local alpha = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		alpha:SetPoint("LEFT", alpha_text, "RIGHT", 10, 0)
		alpha:SetSize(30, 20)
		alpha:SetAutoFocus(false)
		alpha:ClearFocus()
		alpha:SetText(LolzenUIcfg["artifactbar_alpha"])
		alpha:SetCursorPosition(0)

		local bg_alpha_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		bg_alpha_text:SetPoint("LEFT", alpha, "RIGHT", 10, 0)
		bg_alpha_text:SetText("Background alpha:")

		local bg_alpha = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		bg_alpha:SetPoint("LEFT", bg_alpha_text, "RIGHT", 10, 0)
		bg_alpha:SetSize(30, 20)
		bg_alpha:SetAutoFocus(false)
		bg_alpha:ClearFocus()
		bg_alpha:SetText(LolzenUIcfg["artifactbar_bg_alpha"])
		bg_alpha:SetCursorPosition(0)

		local pos_x_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", height_text, "BOTTOMLEFT", 0, -10)
		pos_x_text:SetText("PosX:")

		local pos_x = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 20)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg["artifactbar_posx"])
		pos_x:SetCursorPosition(0)

		local pos_y_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("PosY:")

		local pos_y = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 20)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg["artifactbar_posy"])
		pos_y:SetCursorPosition(0)

		local anchor_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)
		anchor_text:SetText("Anchor:")

		local anchor = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", 10, 0)
		anchor:SetSize(100, 20)
		anchor:SetAutoFocus(false)
		anchor:ClearFocus()
		anchor:SetText(LolzenUIcfg["artifactbar_anchor"])
		anchor:SetCursorPosition(0)

		local parent_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		parent_text:SetPoint("LEFT", anchor, "RIGHT", 5, 0)
		parent_text:SetText("Parent:")

		local parent = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		parent:SetPoint("LEFT", parent_text, "RIGHT", 10, 0)
		parent:SetSize(100, 20)
		parent:SetAutoFocus(false)
		parent:ClearFocus()
		parent:SetText(LolzenUIcfg["artifactbar_parent"])
		parent:SetCursorPosition(0)

		local texture_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		texture_text:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -10)
		texture_text:SetText("|cff5599ffTexture:|r Interface\\AddOns\\LolzenUI\\media\\")

		local texture = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		texture:SetPoint("LEFT", texture_text, "RIGHT", 10, 0)
		texture:SetSize(100, 20)
		texture:SetAutoFocus(false)
		texture:ClearFocus()
		texture:SetText(LolzenUIcfg["artifactbar_texture"])
		texture:SetCursorPosition(0)

		local color_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text:SetPoint("TOPLEFT", texture_text, "BOTTOMLEFT", 0, -10)
		color_text:SetText("Color:")

		local color = ns["artifactbar"]:CreateTexture(nil, "ARTWORK")
		color:SetSize(16, 16)
		color:SetVertexColor(unpack(LolzenUIcfg["artifactbar_color"]))
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)
		color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["artifactbar_texture"])

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f = CreateFrame("Frame", nil, ns["artifactbar"])
		color_f:SetFrameStrata("HIGH")
		color_f:EnableMouse(true)
		color_f:SetAllPoints(color)
		color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["artifactbar_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["artifactbar_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local cb1 = CreateFrame("CheckButton", "pxborder", ns["artifactbar"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", color_text, "BOTTOMLEFT", 0, -8)
		pxborderText:SetText("|cff5599ffdraw a 1px border around the artifactbar|r")

		if LolzenUIcfg["artifactbar_1px_border"] == true then
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
			if LolzenUIcfg["artifactbar_1px_border_round"] == true then
				cb2:SetChecked(true)
			else
				cb2:SetChecked(false)
			end
		end

		local font_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_text:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, -10)
		font_text:SetText("Font:")

		local font = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		font:SetPoint("LEFT", font_text, "RIGHT", 10, 0)
		font:SetSize(200, 20)
		font:SetAutoFocus(false)
		font:ClearFocus()
		font:SetText(LolzenUIcfg["artifactbar_font"])
		font:SetCursorPosition(0)

		local font_size_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_size_text:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -10)
		font_size_text:SetText("Font size:")

		local font_size = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)
		font_size:SetSize(30, 20)
		font_size:SetAutoFocus(false)
		font_size:ClearFocus()
		font_size:SetNumber(LolzenUIcfg["artifactbar_font_size"])
		font_size:SetCursorPosition(0)

		local font_flag_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_flag_text:SetPoint("TOPLEFT", font_size_text, "BOTTOMLEFT", 0, -10)
		font_flag_text:SetText("Font outlining:")

		local font_flag = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", 10, 0)
		font_flag:SetSize(100, 20)
		font_flag:SetAutoFocus(false)
		font_flag:ClearFocus()
		font_flag:SetText(LolzenUIcfg["artifactbar_font_flag"])
		font_flag:SetCursorPosition(0)

		local font_color_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_color_text:SetPoint("TOPLEFT", font_flag_text, "BOTTOMLEFT", 0, -10)
		font_color_text:SetText("Font color:")

		local text_color = ns["artifactbar"]:CreateTexture(nil, "ARTWORK")
		text_color:SetSize(16, 16)
		text_color:SetVertexColor(unpack(LolzenUIcfg["artifactbar_font_color"]))
		text_color:SetPoint("LEFT", font_color_text, "RIGHT", 10, 0)
		text_color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["artifactbar_texture"])

		local function afbarTextSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			text_color:SetVertexColor(r, g, b)
		end

		local function restoreTextPreviousColor()
			text_color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local text_color_f = CreateFrame("Frame", nil, ns["artifactbar"])
		text_color_f:SetFrameStrata("HIGH")
		text_color_f:EnableMouse(true)
		text_color_f:SetAllPoints(text_color)
		text_color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["artifactbar_font_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["artifactbar_font_color"]))
			ColorPickerFrame.cancelFunc = restoreTextPreviousColor
			ColorPickerFrame.func = afbarTextSetNewColor
			ColorPickerFrame:Show()
		end)

		local text_pos_x_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_pos_x_text:SetPoint("TOPLEFT", font_color_text, "BOTTOMLEFT", 0, -10)
		text_pos_x_text:SetText("Text PosX:")

		local text_pos_x = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		text_pos_x:SetPoint("LEFT", text_pos_x_text, "RIGHT", 10, 0)
		text_pos_x:SetSize(30, 20)
		text_pos_x:SetAutoFocus(false)
		text_pos_x:ClearFocus()
		text_pos_x:SetNumber(LolzenUIcfg["artifactbar_text_posx"])
		text_pos_x:SetCursorPosition(0)

		local text_pos_y_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_pos_y_text:SetPoint("LEFT", text_pos_x, "RIGHT", 5, 0)
		text_pos_y_text:SetText("Text PosY:")

		local text_pos_y = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		text_pos_y:SetPoint("LEFT", text_pos_y_text, "RIGHT", 10, 0)
		text_pos_y:SetSize(30, 20)
		text_pos_y:SetAutoFocus(false)
		text_pos_y:ClearFocus()
		text_pos_y:SetNumber(LolzenUIcfg["artifactbar_text_posy"])
		text_pos_y:SetCursorPosition(0)

		local text_anchor_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_anchor_text:SetPoint("LEFT", text_pos_y, "RIGHT", 10, 0)
		text_anchor_text:SetText("Text Anchor1:")

		local text_anchor = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		text_anchor:SetPoint("LEFT", text_anchor_text, "RIGHT", 10, 0)
		text_anchor:SetSize(100, 20)
		text_anchor:SetAutoFocus(false)
		text_anchor:ClearFocus()
		text_anchor:SetText(LolzenUIcfg["artifactbar_text_anchor1"])
		text_anchor:SetCursorPosition(0)

		local text_anchor2_text = ns["artifactbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_anchor2_text:SetPoint("LEFT", text_anchor, "RIGHT", 5, 0)
		text_anchor2_text:SetText("Text Anchor2:")

		local text_anchor2 = CreateFrame("EditBox", nil, ns["artifactbar"], "InputBoxTemplate")
		text_anchor2:SetPoint("LEFT", text_anchor2_text, "RIGHT", 10, 0)
		text_anchor2:SetSize(100, 20)
		text_anchor2:SetAutoFocus(false)
		text_anchor2:ClearFocus()
		text_anchor2:SetText(LolzenUIcfg["artifactbar_text_anchor2"])
		text_anchor2:SetCursorPosition(0)
		
		ns["artifactbar"].okay = function(self)
			LolzenUIcfg["artifactbar_height"] = tonumber(height:GetText())
			LolzenUIcfg["artifactbar_width"] = tonumber(width:GetText())
			LolzenUIcfg["artifactbar_anchor"] = anchor:GetText()
			LolzenUIcfg["artifactbar_parent"] = parent:GetText()
			LolzenUIcfg["artifactbar_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg["artifactbar_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg["artifactbar_texture"] = texture:GetText()
			LolzenUIcfg["artifactbar_alpha"] = tonumber(alpha:GetText())
			LolzenUIcfg["artifactbar_bg_alpha"] = tonumber(bg_alpha:GetText())
			LolzenUIcfg["artifactbar_color"] = {color:GetVertexColor()}
			if cb1:GetChecked(true) then
				LolzenUIcfg["artifactbar_1px_border"] = true
			else
				LolzenUIcfg["artifactbar_1px_border"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg["artifactbar_1px_border_round"] = true
			else
				LolzenUIcfg["artifactbar_1px_border_round"] = false
			end
			LolzenUIcfg["artifactbar_font"] = font:GetText()
			LolzenUIcfg["artifactbar_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg["artifactbar_font_flag"] = font_flag:GetText()
			LolzenUIcfg["artifactbar_font_color"] = {text_color:GetVertexColor()}
			LolzenUIcfg["artifactbar_text_posx"] = tonumber(text_pos_x:GetText())
			LolzenUIcfg["artifactbar_text_posy"] = tonumber(text_pos_y:GetText())
			LolzenUIcfg["artifactbar_text_anchor1"] = text_anchor:GetText()
			LolzenUIcfg["artifactbar_text_anchor2"] = text_anchor2:GetText()
		end

		ns["artifactbar"].default = function(self)
			LolzenUIcfg["artifactbar_height"] = 4
			LolzenUIcfg["artifactbar_width"] = 378
			LolzenUIcfg["artifactbar_anchor"] = "BOTTOM"
			LolzenUIcfg["artifactbar_parent"] = "UIParent"
			LolzenUIcfg["artifactbar_posx"] = 0
			LolzenUIcfg["artifactbar_posy"] = 120
			LolzenUIcfg["artifactbar_texture"] = "statusbar.tga"
			LolzenUIcfg["artifactbar_alpha"] = 0.4
			LolzenUIcfg["artifactbar_bg_alpha"] = 0.5
			LolzenUIcfg["artifactbar_color"] = {1, 1, 0.7}
			LolzenUIcfg["artifactbar_1px_border"] = true
			LolzenUIcfg["artifactbar_1px_border_round"] = true
			LolzenUIcfg["artifactbar_font"] = "DroidSansBold.ttf"
			LolzenUIcfg["artifactbar_font_size"] = 10
			LolzenUIcfg["artifactbar_font_flag"] = "THINOUTLINE"
			LolzenUIcfg["artifactbar_font_color"] = {1, 1, 1}
			LolzenUIcfg["artifactbar_text_posx"] = 0
			LolzenUIcfg["artifactbar_text_posy"] = -2
			LolzenUIcfg["artifactbar_text_anchor1"] = "BOTTOM"
			LolzenUIcfg["artifactbar_text_anchor2"] = "TOP"
			ReloadUI()
		end
	end
end)