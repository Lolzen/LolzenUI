--// fonts // --

local addon, ns = ...

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["fonts"] == false then return end

		DAMAGE_TEXT_FONT = "Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf";
		UNIT_NAME_FONT   = "Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf";
		NAMEPLATE_FONT   = "Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf";
		STANDARD_TEXT_FONT = "Interface\\AddOns\\LolzenUI\\fonts\\DroidSans.ttf";
	end
end)