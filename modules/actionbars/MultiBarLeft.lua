--// MultiBarLeft //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		MultiBarLeftButton1:ClearAllPoints()
		MultiBarLeftButton1:SetPoint("TOPLEFT", MultiBarRightButton1, "TOPLEFT", -33, 0)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbl = _G["MultiBarLeftButton"..i]
			mbl:SetSize(LolzenUIcfg["actiobar_button_size"], LolzenUIcfg["actiobar_button_size"])
		end
		modded = true
	end
end)