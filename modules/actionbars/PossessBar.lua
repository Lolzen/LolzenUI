--// PossessBar //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		PossessButton1:ClearAllPoints()
		PossessButton1:SetPoint("BOTTOMLEFT", MultiBarBottomRightButton1, "TOPLEFT", 25, 30)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local pb = _G["PossessButton"..i]
			if pb then
				pb:SetSize(LolzenUIcfg["actiobar_button_size"], LolzenUIcfg["actiobar_button_size"])
			end
		end
		modded = true
	end
end)