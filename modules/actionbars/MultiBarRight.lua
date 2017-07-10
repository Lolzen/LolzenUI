--// MultiBarRight //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		MultiBarRightButton1:ClearAllPoints()
		MultiBarRightButton1:SetPoint("RIGHT", UIParent, "RIGHT", -2, 150)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbr = _G["MultiBarRightButton"..i]
			mbr:SetSize(LolzenUIcfg["actiobar_button_size"], LolzenUIcfg["actiobar_button_size"])
		end
		modded = true
	end
end)