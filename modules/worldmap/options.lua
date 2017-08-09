--// options for worldmap //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "worldmap")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["worldmap"] == true then

		local title = ns["worldmap"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["worldmap"], 16, -16)
		title:SetText("|cff5599ff"..ns["worldmap"].name.."|r")

		local about = ns["worldmap"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Scales the Worldmap")

		local scale = ns["worldmap"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		scale:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		scale:SetText("|cff5599ffSet the WorldMap scale:|r")
		
		local eb = CreateFrame("EditBox", nil, ns["worldmap"], "InputBoxTemplate")
		eb:SetPoint("LEFT", scale, "RIGHT", 10, 0)
		eb:SetSize(30, 50)
		eb:SetAutoFocus(false)
		eb:ClearFocus()
		eb:SetNumber(LolzenUIcfg.worldmap["worldmap_scale"])
		eb:SetCursorPosition(0)

		ns["worldmap"].okay = function(self)
			LolzenUIcfg.worldmap["worldmap_scale"] = tonumber(eb:GetText())
		end

		ns["worldmap"].default = function(self)
			LolzenUIcfg.worldmap["worldmap_scale"] = 1
			ReloadUI()
		end

		local desc = ns["worldmap"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		desc:SetPoint("TOPLEFT", scale, "BOTTOMLEFT", 0, -16)
		desc:SetText("|cffffffffOnly use numbers or numbers with decimals (0.75), otherwise it will default to 1|r")
	end
end)