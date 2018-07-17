--// versioncheck // --

local _, ns = ...

ns.RegisterModule("versioncheck", true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["versioncheck"] == false then return end

		local version, build, date, tocversion = GetBuildInfo()
		local addonversion = GetAddOnMetadata(addon, "Version")
		if not string.find(addonversion, version) then
			print("|cff5599ffLolzenUI|r: Version numbers don't match!")
			print("Please look for an update at: http://www.wowinterface.com/downloads/info24512-LolzenUI.html or https://github.com/Lolzen/LolzenUI (dev version)")
			print("WoW patch version: "..version..", LolzenUI version: "..addonversion)
		end
	end
end)