--// options for fonts //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "fonts")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["fonts"] == true then

		local title = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["fonts"], 16, -16)
		title:SetText("|cff5599ff"..ns["fonts"].name.."|r")

		local about = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Changes the fonts used in WoW")

		local dmg_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		dmg_text:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		dmg_text:SetText("|cff5599ffDAMAGE_TEXT_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local dmg = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		dmg:SetPoint("LEFT", dmg_text, "RIGHT", 10, 0)
		dmg:SetSize(200, 20)
		dmg:SetAutoFocus(false)
		dmg:ClearFocus()
		dmg:SetText(LolzenUIcfg.fonts["fonts_DAMAGE_TEXT_FONT"])
		dmg:SetCursorPosition(0)

		local unit_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		unit_text:SetPoint("TOPLEFT", dmg_text, "BOTTOMLEFT", 0, -8)
		unit_text:SetText("|cff5599ffUNIT_NAME_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local unit = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		unit:SetPoint("LEFT", unit_text, "RIGHT", 10, 0)
		unit:SetSize(200, 20)
		unit:SetAutoFocus(false)
		unit:ClearFocus()
		unit:SetText(LolzenUIcfg.fonts["fonts_UNIT_NAME_FONT"])
		unit:SetCursorPosition(0)

		local np_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		np_text:SetPoint("TOPLEFT", unit_text, "BOTTOMLEFT", 0, -8)
		np_text:SetText("|cff5599ffNAMEPLATE_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local np = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		np:SetPoint("LEFT", np_text, "RIGHT", 10, 0)
		np:SetSize(200, 20)
		np:SetAutoFocus(false)
		np:ClearFocus()
		np:SetText(LolzenUIcfg.fonts["fonts_NAMEPLATE_FONT"])
		np:SetCursorPosition(0)

		local standard_text = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		standard_text:SetPoint("TOPLEFT", np_text, "BOTTOMLEFT", 0, -8)
		standard_text:SetText("|cff5599ffSTANDARD_TEXT_FONT:|r Interface\\AddOns\\LolzenUI\\fonts\\")

		local standard = CreateFrame("EditBox", nil, ns["fonts"], "InputBoxTemplate")
		standard:SetPoint("LEFT", standard_text, "RIGHT", 10, 0)
		standard:SetSize(200, 20)
		standard:SetAutoFocus(false)
		standard:ClearFocus()
		standard:SetText(LolzenUIcfg.fonts["fonts_STANDARD_TEXT_FONT"])
		standard:SetCursorPosition(0)

		local tip = ns["fonts"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		tip:SetPoint("TOPLEFT", standard_text, "BOTTOMLEFT", 0, -20)
		tip:SetText("|cff5599ffPROTIP:|r The fonts have to have been in the folder BEFORE the WoW client was started.")

		ns["fonts"].okay = function(self)
			LolzenUIcfg.fonts["fonts_DAMAGE_TEXT_FONT"] = dmg:GetText()
			LolzenUIcfg.fonts["fonts_UNIT_NAME_FONT"] = unit:GetText()
			LolzenUIcfg.fonts["fonts_NAMEPLATE_FONT"] = np:GetText()
			LolzenUIcfg.fonts["fonts_STANDARD_TEXT_FONT"] = standard:GetText()
		end

		ns["fonts"].default = function(self)
			LolzenUIcfg.fonts["fonts_DAMAGE_TEXT_FONT"] = "DroidSansBold.ttf"
			LolzenUIcfg.fonts["fonts_UNIT_NAME_FONT"] = "DroidSans.ttf"
			LolzenUIcfg.fonts["fonts_NAMEPLATE_FONT"] = "DroidSans.ttf"
			LolzenUIcfg.fonts["fonts_STANDARD_TEXT_FONT"] = "DroidSans.ttf"
			ReloadUI()
		end
	end
end)