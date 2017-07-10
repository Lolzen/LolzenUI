--// MultiBarBottomLeft //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		MultiBarBottomLeftButton1:ClearAllPoints()
		MultiBarBottomLeftButton1:SetPoint("BOTTOMLEFT", ActionButton1, "TOPLEFT", 0, 5)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbbl = _G["MultiBarBottomLeftButton"..i]
			mbbl:SetSize(LolzenUIcfg["actiobar_button_size"], LolzenUIcfg["actiobar_button_size"])
		end
		modded = true
	end
end)