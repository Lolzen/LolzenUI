--// options for unitframes //--

local addon, ns = ...

ns.RegisterModule("unitframes")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["unitframes"] == true then

		local title = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["unitframes"], 16, -16)
		title:SetText("|cff5599ff"..ns["unitframes"].name.."|r")

		local about = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Unitframes; needs oUF to function properly!")

		local notice = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		notice:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		notice:SetText("|cff5599ffTO BE DONE; ToDo:*bossframe*cleanup|r")

--		local v2 = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v2:SetPoint("TOPLEFT", v1, "BOTTOMLEFT", 0, -8)
--		v2:SetText("|cff5599ffWoW Patch verion:|r "..version)

--		local v3 = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v3:SetPoint("TOPLEFT", v2, "BOTTOMLEFT", 0, 0)
--		v3:SetText("|cff5599ffWoW TOC verion:|r "..tocversion)

--		local v4 = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v4:SetPoint("TOPLEFT", v3, "BOTTOMLEFT", 0, 0)
--		v4:SetText("|cff5599ffWoW build:|r "..build)

--		local v5 = ns["unitframes"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
--		v5:SetPoint("TOPLEFT", v4, "BOTTOMLEFT", 0, 0)
--		v4:SetText("|cff5599ffWoW build date: |r"..date)
	end
end)