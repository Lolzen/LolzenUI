--// options for slashcommands //--

local addon, ns = ...

ns.RegisterModule("slashcommands")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["slashcommands"] == true then

		local title = ns.createTitle("slashcommands")

		local about = ns.createDescription("slashcommands", "these are the slashcommands available:")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local header1 = ns.createHeader("slashcommands", "/rl")
		header1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local desc1 = ns.createFonstring("slashcommands", "a short version of /reload")
		desc1:SetPoint("TOPLEFT", header1, "BOTTOMLEFT", 0, 0)

		local header2 = ns.createHeader("slashcommands", "/frame")
		header2:SetPoint("TOPLEFT", desc1, "BOTTOMLEFT", 0, -20)

		local desc2 = ns.createFonstring("slashcommands", "prints the framename the mouse is hovering above")
		desc2:SetPoint("TOPLEFT", header2, "BOTTOMLEFT", 0, 0)

		local header3 = ns.createHeader("slashcommands", "/child")
		header3:SetPoint("TOPLEFT", desc2, "BOTTOMLEFT", 0, -20)

		local desc3 = ns.createFonstring("slashcommands", "prints the frames's childnames the mouse is hovering above")
		desc3:SetPoint("TOPLEFT", header3, "BOTTOMLEFT", 0, 0)

		local header4 = ns.createHeader("slashcommands", "/gm")
		header4:SetPoint("TOPLEFT", desc3, "BOTTOMLEFT", 0, -20)

		local desc4 = ns.createFonstring("slashcommands", "opens up the helpeframe (for submitting tickets etc)")
		desc4:SetPoint("TOPLEFT", header4, "BOTTOMLEFT", 0, 0)

		local header5 = ns.createHeader("slashcommands", "|cff5599ff/lolzen|r |cffffffffor|r |cff5599ff/lolzenui|r")
		header5:SetPoint("TOPLEFT", desc4, "BOTTOMLEFT", 0, -20)

		local desc5 = ns.createFonstring("slashcommands", "opens the optionpanel of LolzenUI")
		desc5:SetPoint("TOPLEFT", header5, "BOTTOMLEFT", 0, 0)
	end
end)