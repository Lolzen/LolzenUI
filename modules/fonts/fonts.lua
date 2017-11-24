--// fonts // --

local _, ns = ...

ns.RegisterModule("fonts")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["fonts"] == false then return end

		DAMAGE_TEXT_FONT   = "Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.fonts["fonts_DAMAGE_TEXT_FONT"]
		UNIT_NAME_FONT     = "Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.fonts["fonts_UNIT_NAME_FONT"]
		NAMEPLATE_FONT     = "Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.fonts["fonts_NAMEPLATE_FONT"]
		STANDARD_TEXT_FONT = "Interface\\AddOns\\LolzenUI\\fonts\\"..LolzenUIcfg.fonts["fonts_STANDARD_TEXT_FONT"]
	end
end)