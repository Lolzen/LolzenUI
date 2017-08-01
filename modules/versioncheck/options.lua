--// options for versioncheck //--

local addon, ns = ...

if not ns.modules["actionabars"] then
	tinsert(ns.modules, "versioncheck")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg["versioncheck"] == true then
		local version, build, date, tocversion = GetBuildInfo()
		local addonversion = GetAddOnMetadata(addon, "Version")

		local title = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["versioncheck"], 16, -16)
		title:SetText("|cff5599ff"..ns["versioncheck"].name.."|r")

		local about = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Gives a warning if the verion seems outdated")

		local v1 = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		v1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		v1:SetText("|cff5599ffAddon verion:|r |cffffffff"..addonversion.."|r")

		local v2 = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		v2:SetPoint("TOPLEFT", v1, "BOTTOMLEFT", 0, -8)
		v2:SetText("|cff5599ffWoW Patch verion:|r "..version)

		local v3 = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		v3:SetPoint("TOPLEFT", v2, "BOTTOMLEFT", 0, 0)
		v3:SetText("|cff5599ffWoW TOC verion:|r "..tocversion)

		local v4 = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		v4:SetPoint("TOPLEFT", v3, "BOTTOMLEFT", 0, 0)
		v4:SetText("|cff5599ffWoW build:|r "..build)

		local v5 = ns["versioncheck"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		v5:SetPoint("TOPLEFT", v4, "BOTTOMLEFT", 0, 0)
		v4:SetText("|cff5599ffWoW build date: |r"..date)
	end
end)