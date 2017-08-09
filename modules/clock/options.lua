--// options for clock //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "clock")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["clock"] == true then

		local title = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["clock"], 16, -16)
		title:SetText("|cff5599ff"..ns["clock"].name.."|r")

		local about = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("A clock with Addon stats along with fps and latency overwiev on mouseover")

		local main = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		main:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		main:SetText("|cff5599ffHours & Minutes:|r")

		local font_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_text:SetPoint("TOPLEFT", main, "BOTTOMLEFT", 0, -10)
		font_text:SetText("|cff5599ffFont:|r")

		local font = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		font:SetPoint("LEFT", font_text, "RIGHT", 10, 0)
		font:SetSize(200, 20)
		font:SetAutoFocus(false)
		font:ClearFocus()
		font:SetText(LolzenUIcfg.clock["clock_font"])
		font:SetCursorPosition(0)

		local font_size_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_size_text:SetPoint("LEFT", font, "RIGHT", 10, 0)
		font_size_text:SetText("Size:")

		local font_size = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		font_size:SetPoint("LEFT", font_size_text, "RIGHT", 10, 0)
		font_size:SetSize(30, 20)
		font_size:SetAutoFocus(false)
		font_size:ClearFocus()
		font_size:SetNumber(LolzenUIcfg.clock["clock_font_size"])
		font_size:SetCursorPosition(0)

		local font_flag_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		font_flag_text:SetPoint("LEFT", font_size, "RIGHT", 10, 0)
		font_flag_text:SetText("Flag:")

		local font_flag = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		font_flag:SetPoint("LEFT", font_flag_text, "RIGHT", 10, 0)
		font_flag:SetSize(100, 20)
		font_flag:SetAutoFocus(false)
		font_flag:ClearFocus()
		font_flag:SetText(LolzenUIcfg.clock["clock_font_flag"])
		font_flag:SetCursorPosition(0)

		local color_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		color_text:SetPoint("LEFT", font_flag, "RIGHT", 10, 0)
		color_text:SetText("Color:")

		local color = ns["clock"]:CreateTexture(nil, "ARTWORK")
		color:SetSize(16, 16)
		color:SetVertexColor(unpack(LolzenUIcfg.clock["clock_color"]))
		color:SetPoint("LEFT", color_text, "RIGHT", 10, 0)
		color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")

		local function afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			color:SetVertexColor(r, g, b)
		end

		local function restorePreviousColor()
			color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local color_f = CreateFrame("Frame", nil, ns["clock"])
		color_f:SetFrameStrata("HIGH")
		color_f:EnableMouse(true)
		color_f:SetAllPoints(color)
		color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg.clock["clock_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg.clock["clock_color"]))
			ColorPickerFrame.cancelFunc = restorePreviousColor
			ColorPickerFrame.func = afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local secs = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		secs:SetPoint("TOPLEFT", font_text, "BOTTOMLEFT", 0, -20)
		secs:SetText("|cff5599ffSeconds:|r")

		local seconds_font_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		seconds_font_text:SetPoint("TOPLEFT", secs, "BOTTOMLEFT", 0, -10)
		seconds_font_text:SetText("|cff5599ffFont:|r")

		local seconds_font = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		seconds_font:SetPoint("LEFT", seconds_font_text, "RIGHT", 10, 0)
		seconds_font:SetSize(200, 20)
		seconds_font:SetAutoFocus(false)
		seconds_font:ClearFocus()
		seconds_font:SetText(LolzenUIcfg.clock["clock_font_seconds"])
		seconds_font:SetCursorPosition(0)

		local seconds_font_size_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		seconds_font_size_text:SetPoint("LEFT", seconds_font, "RIGHT", 10, 0)
		seconds_font_size_text:SetText("Size:")

		local seconds_font_size = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		seconds_font_size:SetPoint("LEFT", seconds_font_size_text, "RIGHT", 10, 0)
		seconds_font_size:SetSize(30, 20)
		seconds_font_size:SetAutoFocus(false)
		seconds_font_size:ClearFocus()
		seconds_font_size:SetNumber(LolzenUIcfg.clock["clock_seconds_font_size"])
		seconds_font_size:SetCursorPosition(0)

		local seconds_font_flag_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		seconds_font_flag_text:SetPoint("LEFT", seconds_font_size, "RIGHT", 10, 0)
		seconds_font_flag_text:SetText("Flag:")

		local seconds_font_flag = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		seconds_font_flag:SetPoint("LEFT", seconds_font_flag_text, "RIGHT", 10, 0)
		seconds_font_flag:SetSize(100, 20)
		seconds_font_flag:SetAutoFocus(false)
		seconds_font_flag:ClearFocus()
		seconds_font_flag:SetText(LolzenUIcfg.clock["clock_seconds_font_flag"])
		seconds_font_flag:SetCursorPosition(0)

		local seconds_color_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		seconds_color_text:SetPoint("LEFT", seconds_font_flag, "RIGHT", 10, 0)
		seconds_color_text:SetText("Color:")

		local seconds_color = ns["clock"]:CreateTexture(nil, "ARTWORK")
		seconds_color:SetSize(16, 16)
		seconds_color:SetVertexColor(unpack(LolzenUIcfg.clock["clock_seconds_color"]))
		seconds_color:SetPoint("LEFT", seconds_color_text, "RIGHT", 10, 0)
		seconds_color:SetTexture("Interface\\AddOns\\LolzenUI\\media\\statusbar")

		local function seconds_afbarSetNewColor()
			r, g, b = ColorPickerFrame:GetColorRGB()
			seconds_color:SetVertexColor(r, g, b)
		end

		local function seconds_restorePreviousColor()
			seconds_color:SetVertexColor(unpack(ColorPickerFrame.previousValues))
		end

		local seconds_color_f = CreateFrame("Frame", nil, ns["clock"])
		seconds_color_f:SetFrameStrata("HIGH")
		seconds_color_f:EnableMouse(true)
		seconds_color_f:SetAllPoints(seconds_color)
		seconds_color_f:SetScript("OnMouseDown", function(self)
			-- clear previous values
			ColorPickerFrame.previousValues = nil
			ColorPickerFrame.cancelFunc = nil
			ColorPickerFrame.func = nil
			-- and fill with the relevant ones
			ColorPickerFrame.previousValues = LolzenUIcfg.clock["clock_seconds_color"]
			ColorPickerFrame:SetColorRGB(unpack(LolzenUIcfg.clock["clock_seconds_color"]))
			ColorPickerFrame.cancelFunc = seconds_restorePreviousColor
			ColorPickerFrame.func = seconds_afbarSetNewColor
			ColorPickerFrame:Show()
		end)

		local frame = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		frame:SetPoint("TOPLEFT", seconds_font_text, "BOTTOMLEFT", 0, -20)
		frame:SetText("|cff5599ffFrame:|r")

		local pos_x_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_x_text:SetPoint("TOPLEFT", frame, "BOTTOMLEFT", 0, -10)
		pos_x_text:SetText("PosX:")

		local pos_x = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		pos_x:SetPoint("LEFT", pos_x_text, "RIGHT", 10, 0)
		pos_x:SetSize(30, 20)
		pos_x:SetAutoFocus(false)
		pos_x:ClearFocus()
		pos_x:SetNumber(LolzenUIcfg.clock["clock_posx"])
		pos_x:SetCursorPosition(0)

		local pos_y_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		pos_y_text:SetPoint("LEFT", pos_x, "RIGHT", 5, 0)
		pos_y_text:SetText("PosY:")

		local pos_y = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		pos_y:SetPoint("LEFT", pos_y_text, "RIGHT", 10, 0)
		pos_y:SetSize(30, 20)
		pos_y:SetAutoFocus(false)
		pos_y:ClearFocus()
		pos_y:SetNumber(LolzenUIcfg.clock["clock_posy"])
		pos_y:SetCursorPosition(0)

		local anchor_text = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text:SetPoint("LEFT", pos_y, "RIGHT", 5, 0)
		anchor_text:SetText("Anchor1:")

		local anchor = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		anchor:SetPoint("LEFT", anchor_text, "RIGHT", 10, 0)
		anchor:SetSize(100, 20)
		anchor:SetAutoFocus(false)
		anchor:ClearFocus()
		anchor:SetText(LolzenUIcfg.clock["clock_anchor1"])
		anchor:SetCursorPosition(0)

		local anchor_text2 = ns["clock"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		anchor_text2:SetPoint("LEFT", anchor, "RIGHT", 5, 0)
		anchor_text2:SetText("Anchor2:")

		local anchor2 = CreateFrame("EditBox", nil, ns["clock"], "InputBoxTemplate")
		anchor2:SetPoint("LEFT", anchor_text2, "RIGHT", 10, 0)
		anchor2:SetSize(100, 20)
		anchor2:SetAutoFocus(false)
		anchor2:ClearFocus()
		anchor2:SetText(LolzenUIcfg.clock["clock_anchor2"])
		anchor2:SetCursorPosition(0)

		ns["clock"].okay = function(self)
			LolzenUIcfg.clock["clock_color"] = {color:GetVertexColor()}
			LolzenUIcfg.clock["clock_seconds_color"] = {seconds_color:GetVertexColor()}
			LolzenUIcfg.clock["clock_font"] = font:GetText()
			LolzenUIcfg.clock["clock_font_seconds"] = seconds_font:GetText()
			LolzenUIcfg.clock["clock_font_size"] = tonumber(font_size:GetText())
			LolzenUIcfg.clock["clock_seconds_font_size"] = tonumber(seconds_font_size:GetText())
			LolzenUIcfg.clock["clock_font_flag"] = font_flag:GetText()
			LolzenUIcfg.clock["clock_seconds_font_flag"] = seconds_font_flag:GetText()
			LolzenUIcfg.clock["clock_anchor1"] = anchor:GetText()
			LolzenUIcfg.clock["clock_anchor2"] = anchor2:GetText()
			LolzenUIcfg.clock["clock_posx"] = tonumber(pos_x:GetText())
			LolzenUIcfg.clock["clock_posy"] = tonumber(pos_y:GetText())
		end

		ns["clock"].default = function(self)
			LolzenUIcfg.clock["clock_color"] = {0.85, 0.55, 0}
			LolzenUIcfg.clock["clock_seconds_color"] = {1, 1, 1}
			LolzenUIcfg.clock["clock_font"] = "DroidSansBold.ttf"
			LolzenUIcfg.clock["clock_font_seconds"] = "DroidSans.ttf"
			LolzenUIcfg.clock["clock_font_size"] = 20
			LolzenUIcfg.clock["clock_seconds_font_size"] = 14
			LolzenUIcfg.clock["clock_font_flag"] = "OUTLINE"
			LolzenUIcfg.clock["clock_seconds_font_flag"] = "THINOUTLINE"
			LolzenUIcfg.clock["clock_anchor1"] = "TOPRIGHT"
			LolzenUIcfg.clock["clock_anchor2"] = "TOPRIGHT"
			LolzenUIcfg.clock["clock_posx"] = -5
			LolzenUIcfg.clock["clock_posy"] = -9
			ReloadUI()
		end
	end
end)