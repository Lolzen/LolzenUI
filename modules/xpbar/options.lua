--// options for xpbar //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "xpbar")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["xpbar"] == true then

		local title = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["xpbar"], 16, -16)
		title:SetText("|cff5599ff"..ns["xpbar"].name.."|r")

		local about = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("A bar which shows pretige/honor in bgs, rep at the watched faction or alternatively experience")

		local height_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		height_text:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		height_text:SetText("Height:")

		local height = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		height:SetPoint("LEFT", height_text, "RIGHT", 10, 0)
		height:SetSize(30, 20)
		height:SetAutoFocus(false)
		height:ClearFocus()
		height:SetNumber(LolzenUIcfg["xpbar_height"])
		height:SetCursorPosition(0)

		local width_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		width_text:SetPoint("LEFT", height, "RIGHT", 10, 0)
		width_text:SetText("Width:")

		local width = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		width:SetPoint("LEFT", width_text, "RIGHT", 10, 0)
		width:SetSize(40, 20)
		width:SetAutoFocus(false)
		width:ClearFocus()
		width:SetNumber(LolzenUIcfg["xpbar_width"])
		width:SetCursorPosition(0)

		local alpha_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		alpha_text:SetPoint("LEFT", width, "RIGHT", 10, 0)
		alpha_text:SetText("Alpha:")

		local alpha = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		alpha:SetPoint("LEFT", alpha_text, "RIGHT", 10, 0)
		alpha:SetSize(30, 20)
		alpha:SetAutoFocus(false)
		alpha:ClearFocus()
		alpha:SetText(LolzenUIcfg["xpbar_alpha"])
		alpha:SetCursorPosition(0)

		local bg_alpha_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		bg_alpha_text:SetPoint("LEFT", alpha, "RIGHT", 10, 0)
		bg_alpha_text:SetText("Background alpha:")

		local bg_alpha = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		bg_alpha:SetPoint("LEFT", bg_alpha_text, "RIGHT", 10, 0)
		bg_alpha:SetSize(30, 20)
		bg_alpha:SetAutoFocus(false)
		bg_alpha:ClearFocus()
		bg_alpha:SetText(LolzenUIcfg["xpbar_bg_alpha"])
		bg_alpha:SetCursorPosition(0)

		local pos_x_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", height_text, "BOTTOMLEFT", 0, -10)
		pos_x_text:SetText("PosX:")

		local pos_x = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 20)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg["xpbar_posx"])
		pos_x:SetCursorPosition(0)

		local pos_y_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("PosY:")

		local pos_y = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 20)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg["xpbar_posy"])
		pos_y:SetCursorPosition(0)

		local anchor_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)
		anchor_text:SetText("Anchor:")

		local anchor = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", 10, 0)
		anchor:SetSize(100, 20)
		anchor:SetAutoFocus(false)
		anchor:ClearFocus()
		anchor:SetText(LolzenUIcfg["xpbar_anchor"])
		anchor:SetCursorPosition(0)

		local parent_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		parent_text:SetPoint("LEFT", anchor, "RIGHT", 5, 0)
		parent_text:SetText("Parent:")

		local parent = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		parent:SetPoint("LEFT", parent_text, "RIGHT", 10, 0)
		parent:SetSize(100, 20)
		parent:SetAutoFocus(false)
		parent:ClearFocus()
		parent:SetText(LolzenUIcfg["xpbar_parent"])
		parent:SetCursorPosition(0)

		local texture_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		texture_text:SetPoint("TOPLEFT", pos_x_text, "BOTTOMLEFT", 0, -10)
		texture_text:SetText("|cff5599ffTexture:|r Interface\\AddOns\\LolzenUI\\media\\")

		local texture = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		texture:SetPoint("LEFT", texture_text, "RIGHT", 10, 0)
		texture:SetSize(100, 20)
		texture:SetAutoFocus(false)
		texture:ClearFocus()
		texture:SetText(LolzenUIcfg["xpbar_texture"])
		texture:SetCursorPosition(0)

		local color_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text:SetPoint("TOPLEFT", texture_text, "BOTTOMLEFT", 0, -10)
		color_text:SetText("Regular xpbar color:")

		local color = ns["xpbar"]:CreateTexture(nil, "ARTWORK")
		color:SetSize(16, 16)
		color:SetVertexColor(unpack(LolzenUIcfg["xpbar_xp_color"]))
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)
		color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["xpbar_texture"])

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f = CreateFrame("Frame", nil, ns["xpbar"])
		color_f:SetFrameStrata("HIGH")
		color_f:EnableMouse(true)
		color_f:SetAllPoints(color)
		color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["xpbar_xp_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["xpbar_xp_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local color_text2 = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text2:SetPoint("LEFT", color, "RIGHT", 15, 0)
		color_text2:SetText("Rested xpbar color:")

		local color2 = ns["xpbar"]:CreateTexture(nil, "ARTWORK")
		color2:SetSize(16, 16)
		color2:SetVertexColor(unpack(LolzenUIcfg["xpbar_xp_rested_color"]))
		color2:SetPoint("LEFT", color_text2, "RIGHT", 10, 0)
		color2:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["xpbar_texture"])

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color2:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color2:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f2 = CreateFrame("Frame", nil, ns["xpbar"])
		color_f2:SetFrameStrata("HIGH")
		color_f2:EnableMouse(true)
		color_f2:SetAllPoints(color2)
		color_f2:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["xpbar_xp_rested_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["xpbar_xp_rested_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local color_text3 = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text3:SetPoint("LEFT", color2, "RIGHT", 15, 0)
		color_text3:SetText("PvP color (prestige):")

		local color3 = ns["xpbar"]:CreateTexture(nil, "ARTWORK")
		color3:SetSize(16, 16)
		color3:SetVertexColor(unpack(LolzenUIcfg["xpbar_pvp_color"]))
		color3:SetPoint("LEFT", color_text3, "RIGHT", 10, 0)
		color3:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["xpbar_texture"])

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color3:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color3:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f3 = CreateFrame("Frame", nil, ns["xpbar"])
		color_f3:SetFrameStrata("HIGH")
		color_f3:EnableMouse(true)
		color_f3:SetAllPoints(color3)
		color_f3:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["xpbar_pvp_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["xpbar_pvp_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local color_text4 = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text4:SetPoint("LEFT", color3, "RIGHT", 15, 0)
		color_text4:SetText("Paragon xp color:")

		local color4 = ns["xpbar"]:CreateTexture(nil, "ARTWORK")
		color4:SetSize(16, 16)
		color4:SetVertexColor(unpack(LolzenUIcfg["xpbar_paragon_color"]))
		color4:SetPoint("LEFT", color_text4, "RIGHT", 10, 0)
		color4:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["xpbar_texture"])

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color4:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color4:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f4 = CreateFrame("Frame", nil, ns["xpbar"])
		color_f4:SetFrameStrata("HIGH")
		color_f4:EnableMouse(true)
		color_f4:SetAllPoints(color4)
		color_f4:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["xpbar_paragon_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["xpbar_paragon_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local cb1 = CreateFrame("CheckButton", "pxborder_xp", ns["xpbar"], "ChatConfigCheckButtonTemplate")
		cb1:SetPoint("TOPLEFT", color_text, "BOTTOMLEFT", 0, -8)
		pxborder_xpText:SetText("|cff5599ffdraw a 1px border around the xpbar|r")

		if LolzenUIcfg["xpbar_1px_border"] == true then
			cb1:SetChecked(true)
		else
			cb1:SetChecked(false)
		end

		local cb2 = CreateFrame("CheckButton", "pxborder_round_xp", ns["xpbar"], "ChatConfigCheckButtonTemplate")
		cb2:SetPoint("TOPLEFT", cb1, "BOTTOMLEFT", 0, 0)
		pxborder_round_xpText:SetText("|cff5599ffrounded 1px border|r")

		cb1:SetScript("OnClick", function(self)
			if cb1:GetChecked() == false then
				cb2:Disable()
				pxborder_round_xpText:SetText("|cff555555rounded 1px border|r |cffff5555enable 1px border for this option|r")
			else
				cb2:Enable()
				pxborder_round_xpText:SetText("|cff5599ffrounded 1px border|r")
			end
		end)

		if cb1:GetChecked() == false then
			cb2:Disable()
			pxborder_round_xpText:SetText("|cff555555rounded 1px border|r |cffff5555enable 1px border for this option|r")
		else
			if LolzenUIcfg["xpbar_1px_border_round"] == true then
				cb2:SetChecked(true)
			else
				cb2:SetChecked(false)
			end
		end

		local font_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_text:SetPoint("TOPLEFT", cb2, "BOTTOMLEFT", 0, -10)
		font_text:SetText("Font:")

		local font = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		font:SetPoint("LEFT", font_text, "RIGHT", 10, 0)
		font:SetSize(200, 20)
		font:SetAutoFocus(false)
		font:ClearFocus()
		font:SetText(LolzenUIcfg["xpbar_font"])
		font:SetCursorPosition(0)

		local font_size_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_size_text:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -10)
		font_size_text:SetText("Font size:")

		local font_size = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)
		font_size:SetSize(30, 20)
		font_size:SetAutoFocus(false)
		font_size:ClearFocus()
		font_size:SetNumber(LolzenUIcfg["xpbar_font_size"])
		font_size:SetCursorPosition(0)

		local font_flag_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_flag_text:SetPoint("TOPLEFT", font_size_text, "BOTTOMLEFT", 0, -10)
		font_flag_text:SetText("Font outlining:")

		local font_flag = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", 10, 0)
		font_flag:SetSize(100, 20)
		font_flag:SetAutoFocus(false)
		font_flag:ClearFocus()
		font_flag:SetText(LolzenUIcfg["xpbar_font_flag"])
		font_flag:SetCursorPosition(0)

		local font_color_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_color_text:SetPoint("TOPLEFT", font_flag_text, "BOTTOMLEFT", 0, -10)
		font_color_text:SetText("Font color:")

		local text_color = ns["xpbar"]:CreateTexture(nil, "ARTWORK")
		text_color:SetSize(16, 16)
		text_color:SetVertexColor(unpack(LolzenUIcfg["xpbar_font_color"]))
		text_color:SetPoint("LEFT", font_color_text, "RIGHT", 10, 0)
		text_color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\"..LolzenUIcfg["xpbar_texture"])

		local function afbarTextSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			text_color:SetVertexColor(r, g, b)
		end

		local function restoreTextPreviousColor()
			text_color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local text_color_f = CreateFrame("Frame", nil, ns["xpbar"])
		text_color_f:SetFrameStrata("HIGH")
		text_color_f:EnableMouse(true)
		text_color_f:SetAllPoints(text_color)
		text_color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg["xpbar_font_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg["xpbar_font_color"]))
			ColorPickerFrame.cancelFunc = restoreTextPreviousColor
			ColorPickerFrame.func = afbarTextSetNewColor
			ColorPickerFrame:Show()
		end)

		local text_pos_x_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_pos_x_text:SetPoint("TOPLEFT", font_color_text, "BOTTOMLEFT", 0, -10)
		text_pos_x_text:SetText("Text PosX:")

		local text_pos_x = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		text_pos_x:SetPoint("LEFT", text_pos_x_text, "RIGHT", 10, 0)
		text_pos_x:SetSize(30, 20)
		text_pos_x:SetAutoFocus(false)
		text_pos_x:ClearFocus()
		text_pos_x:SetNumber(LolzenUIcfg["xpbar_text_posx"])
		text_pos_x:SetCursorPosition(0)

		local text_pos_y_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_pos_y_text:SetPoint("LEFT", text_pos_x, "RIGHT", 5, 0)
		text_pos_y_text:SetText("Text PosY:")

		local text_pos_y = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		text_pos_y:SetPoint("LEFT", text_pos_y_text, "RIGHT", 10, 0)
		text_pos_y:SetSize(30, 20)
		text_pos_y:SetAutoFocus(false)
		text_pos_y:ClearFocus()
		text_pos_y:SetNumber(LolzenUIcfg["xpbar_text_posy"])
		text_pos_y:SetCursorPosition(0)

		local text_anchor_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_anchor_text:SetPoint("LEFT", text_pos_y, "RIGHT", 10, 0)
		text_anchor_text:SetText("Text Anchor1:")

		local text_anchor = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		text_anchor:SetPoint("LEFT", text_anchor_text, "RIGHT", 10, 0)
		text_anchor:SetSize(100, 20)
		text_anchor:SetAutoFocus(false)
		text_anchor:ClearFocus()
		text_anchor:SetText(LolzenUIcfg["xpbar_text_anchor1"])
		text_anchor:SetCursorPosition(0)

		local text_anchor2_text = ns["xpbar"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		text_anchor2_text:SetPoint("LEFT", text_anchor, "RIGHT", 5, 0)
		text_anchor2_text:SetText("Text Anchor2:")

		local text_anchor2 = CreateFrame("EditBox", nil, ns["xpbar"], "InputBoxTemplate")
		text_anchor2:SetPoint("LEFT", text_anchor2_text, "RIGHT", 10, 0)
		text_anchor2:SetSize(100, 20)
		text_anchor2:SetAutoFocus(false)
		text_anchor2:ClearFocus()
		text_anchor2:SetText(LolzenUIcfg["xpbar_text_anchor2"])
		text_anchor2:SetCursorPosition(0)

		ns["xpbar"].okay = function(self)
			LolzenUIcfg["xpbar_height"] = tonumber(height:GetText())
			LolzenUIcfg["xpbar_width"] = tonumber(width:GetText())
			LolzenUIcfg["xpbar_anchor"] = anchor:GetText()
			LolzenUIcfg["xpbar_parent"] = parent:GetText()
			LolzenUIcfg["xpbar_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg["xpbar_posy"] = tonumber(pos_y:GetText())
			LolzenUIcfg["xpbar_texture"] = texture:GetText()
			LolzenUIcfg["xpbar_alpha"] = tonumber(alpha:GetText())
			LolzenUIcfg["xpbar_bg_alpha"] = tonumber(bg_alpha:GetText())
			LolzenUIcfg["xpbar_xp_color"] = {color:GetVertexColor()}
			LolzenUIcfg["xpbar_xp_restedcolor"] = {color2:GetVertexColor()}
			LolzenUIcfg["xpbar_pvp_color"] = {color3:GetVertexColor()}
			LolzenUIcfg["xpbar_paragon_color"] = {color4:GetVertexColor()}
			if cb1:GetChecked(true) then
				LolzenUIcfg["xpbar_1px_border"] = true
			else
				LolzenUIcfg["xpbar_1px_border"] = false
			end
			if cb2:GetChecked(true) then
				LolzenUIcfg["xpbar_1px_border_round"] = true
			else
				LolzenUIcfg["xpbar_1px_border_round"] = false
			end
			LolzenUIcfg["xpbar_font"] = font:GetText()
			LolzenUIcfg["xpbar_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg["xpbar_font_flag"] = font_flag:GetText()
			LolzenUIcfg["xpbar_font_color"] = {text_color:GetVertexColor()}
			LolzenUIcfg["xpbar_text_posx"] = tonumber(text_pos_x:GetText())
			LolzenUIcfg["xpbar_text_posy"] = tonumber(text_pos_y:GetText())
			LolzenUIcfg["xpbar_text_anchor1"] = text_anchor:GetText()
			LolzenUIcfg["xpbar_text_anchor2"] = text_anchor2:GetText()
		end

		ns["xpbar"].default = function(self)
			LolzenUIcfg["xpbar_height"] = 4
			LolzenUIcfg["xpbar_width"] = 378
			LolzenUIcfg["xpbar_anchor"] = "BOTTOM"
			LolzenUIcfg["xpbar_parent"] = "UIParent"
			LolzenUIcfg["xpbar_posx"] = 0
			LolzenUIcfg["xpbar_posy"] = 5
			LolzenUIcfg["xpbar_texture"] = "statusbar"
			LolzenUIcfg["xpbar_alpha"] = 0.4
			LolzenUIcfg["xpbar_bg_alpha"] = 0.5
			LolzenUIcfg["xpbar_xp_color"] = {0.6, 0, 0.6}
			LolzenUIcfg["xpbar_xp_restedcolor"] = {46/255, 103/255, 208/255}
			LolzenUIcfg["xpbar_pvp_color"] = {1, 0.4, 0}
			LolzenUIcfg["xpbar_paragon_color"] = {0, 187/255, 255/255}
			LolzenUIcfg["xpbar_1px_border"] = true
			LolzenUIcfg["xpbar_1px_border_round"] = true
			LolzenUIcfg["xpbar_font"] = "DroidSansBold.ttf"
			LolzenUIcfg["xpbar_font_size"] = 10
			LolzenUIcfg["xpbar_font_flag"] = "THINOUTLINE"
			LolzenUIcfg["xpbar_font_color"] = {1, 1, 1}
			LolzenUIcfg["xpbar_text_posx"] = 0
			LolzenUIcfg["xpbar_text_posy"] = -2
			LolzenUIcfg["xpbar_text_anchor1"] = "BOTTOM"
			LolzenUIcfg["xpbar_text_anchor2"] = "TOP"
			ReloadUI()
		end
	end
end)