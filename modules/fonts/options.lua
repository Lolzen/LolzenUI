--// options for fonts //--

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["fonts"] == true then

		local title = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["fonts"], 16, -16)
		title:SetText("|cff5599ff"..ns["fonts"].name.."|r")

		local about = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Changes the fonts used in WoW")

		local notice = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		notice:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		notice:SetText("|cff5599ffWiP|r")

		local dmg_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dmg_text:SetPoint("TOPLEFT", notice, "BOTTOMLEFT", 0, -8)
		dmg_text:SetText("|cff5599ffDAMAGE_TEXT_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local dmg = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		dmg:SetPoint("LEFT", dmg_text, "RIGHT", 10, 0)
		dmg:SetSize(200, 20)
		dmg:SetAutoFocus(false)
		dmg:ClearFocus()
		dmg:SetText(LolzenUIcfg["fonts_DAMAGE_TEXT_FONT"])
		dmg:SetCursorPosition(0)

		local unit_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		unit_text:SetPoint("TOPLEFT", dmg_text, "BOTTOMLEFT", 0, -8)
		unit_text:SetText("|cff5599ffUNIT_NAME_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local unit = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		unit:SetPoint("LEFT", unit_text, "RIGHT", 10, 0)
		unit:SetSize(200, 20)
		unit:SetAutoFocus(false)
		unit:ClearFocus()
		unit:SetText(LolzenUIcfg["fonts_UNIT_NAME_FONT"])
		unit:SetCursorPosition(0)

		local np_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		np_text:SetPoint("TOPLEFT", unit_text, "BOTTOMLEFT", 0, -8)
		np_text:SetText("|cff5599ffNAMEPLATE_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local np = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		np:SetPoint("LEFT", np_text, "RIGHT", 10, 0)
		np:SetSize(200, 20)
		np:SetAutoFocus(false)
		np:ClearFocus()
		np:SetText(LolzenUIcfg["fonts_NAMEPLATE_FONT"])
		np:SetCursorPosition(0)

		local standard_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		standard_text:SetPoint("TOPLEFT", np_text, "BOTTOMLEFT", 0, -8)
		standard_text:SetText("|cff5599ffSTANDARD_TEXT_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local standard = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		standard:SetPoint("LEFT", standard_text, "RIGHT", 10, 0)
		standard:SetSize(200, 20)
		standard:SetAutoFocus(false)
		standard:ClearFocus()
		standard:SetText(LolzenUIcfg["fonts_STANDARD_TEXT_FONT"])
		standard:SetCursorPosition(0)


--		local v3 = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v3:SetPoint("TOPLEFT", v2, "BOTTOMLEFT", 0, 0)
--		v3:SetText("|cff5599ffWoW TOC verion:|r "..tocversion)

--		local v4 = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v4:SetPoint("TOPLEFT", v3, "BOTTOMLEFT", 0, 0)
--		v4:SetText("|cff5599ffWoW build:|r "..build)

--		local v5 = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v5:SetPoint("TOPLEFT", v4, "BOTTOMLEFT", 0, 0)
--		v4:SetText("|cff5599ffWoW build date: |r"..date)
	end
end)