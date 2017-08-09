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