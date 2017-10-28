--// options for versioncheck //--

local addon, ns = ...

ns.RegisterModule("versioncheck")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["versioncheck"] == true then

		local version, build, date, tocversion = GetBuildInfo()
		local addonversion = GetAddOnMetadata(addon, "Version")

		local title = ns.createTitle("versioncheck")

		local about = ns.createDescription("versioncheck", "Gives a warning if the verion seems outdated")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local v1 = ns.createHeader("versioncheck", "|cff5599ffAddon verion:|r |cffffffff"..addonversion.."|r")
		v1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		local v2 = ns.createFonstring("versioncheck", "|cff5599ffWoW Patch verion:|r "..version)
		v2:SetPoint("TOPLEFT", v1, "BOTTOMLEFT", 0, -15)

		local v3 = ns.createFonstring("versioncheck", "|cff5599ffWoW TOC verion:|r "..tocversion)
		v3:SetPoint("TOPLEFT", v2, "BOTTOMLEFT", 0, -8)

		local v4 = ns.createFonstring("versioncheck", "|cff5599ffWoW build:|r "..build)
		v4:SetPoint("TOPLEFT", v3, "BOTTOMLEFT", 0, -8)

		local v5 = ns.createFonstring("versioncheck", "|cff5599ffWoW build date: |r"..date)
		v5:SetPoint("TOPLEFT", v4, "BOTTOMLEFT", 0, -8)
	end
end)