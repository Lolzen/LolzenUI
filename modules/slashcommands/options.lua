--// options for slashcommands //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "slashcommands")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["slashcommands"] == true then
		local title = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["slashcommands"], 16, -16)
		title:SetText("|cff5599ff"..ns["slashcommands"].name.."|r")

		local about = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("these are the available slashcommands:")

		local slash1 = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		slash1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 5, -20)
		slash1:SetText("|cff5599ff/rl|r")

		local slash1desc = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		slash1desc:SetPoint("TOPLEFT", slash1, "BOTTOMLEFT", 0, 0)
		slash1desc:SetText("a short version of /reload")

		local slash2 = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		slash2:SetPoint("TOPLEFT", slash1desc, "BOTTOMLEFT", 0, -20)
		slash2:SetText("|cff5599ff/frame|r")

		local slash2desc = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		slash2desc:SetPoint("TOPLEFT", slash2, "BOTTOMLEFT", 0, 0)
		slash2desc:SetText("prints the framename the mouse is hovering above")

		local slash3 = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		slash3:SetPoint("TOPLEFT", slash2desc, "BOTTOMLEFT", 0, -20)
		slash3:SetText("|cff5599ff/child|r")

		local slash3desc = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		slash3desc:SetPoint("TOPLEFT", slash3, "BOTTOMLEFT", 0, 0)
		slash3desc:SetText("prints the frames's childnames the mouse is hovering above")

		local slash4 = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		slash4:SetPoint("TOPLEFT", slash3desc, "BOTTOMLEFT", 0, -20)
		slash4:SetText("|cff5599ff/gm|r")

		local slash4desc = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		slash4desc:SetPoint("TOPLEFT", slash4, "BOTTOMLEFT", 0, 0)
		slash4desc:SetText("opens up the helpeframe (for submitting tickets etc)")

		local slash5 = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		slash5:SetPoint("TOPLEFT", slash4desc, "BOTTOMLEFT", 0, -20)
		slash5:SetText("|cff5599ff/lolzen|r |cffffffffor|r |cff5599ff/lolzenui|r")

		local slash5desc = ns["slashcommands"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		slash5desc:SetPoint("TOPLEFT", slash5, "BOTTOMLEFT", 0, 0)
		slash5desc:SetText("opens the optionpanel of LolzenUI")
	end
end)