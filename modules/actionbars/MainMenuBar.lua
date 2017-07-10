--// MainMenuBar //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		-- Make the MainMenuBar clickthrough, so it doesn't interfere with other frames placed on the bottom
		MainMenuBar:EnableMouse(false)

		local holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
		holder:SetSize(LolzenUIcfg["actiobar_button_size"]*12+LolzenUIcfg["actionbar_button_spacing"]*11, LolzenUIcfg["actiobar_button_size"])
		holder:SetPoint("BOTTOM", UIParent, 0, 22)

		ActionButton1:ClearAllPoints()
		ActionButton1:SetPoint("BOTTOMLEFT", holder, 0, 0)
		
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local ab = _G["ActionButton"..i]
			ab:SetSize(LolzenUIcfg["actiobar_button_size"], LolzenUIcfg["actiobar_button_size"])
		end
		modded = true
	end
end)