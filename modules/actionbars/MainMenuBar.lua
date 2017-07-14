--// MainMenuBar //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		-- Make the MainMenuBar clickthrough, so it doesn't interfere with other frames placed at the bottom
		MainMenuBar:EnableMouse(false)

		-- Create a holder frame, which the Main Menu Bar can refer to when positioning;
		-- per default it wouldn't be centered
		local holder = CreateFrame("Frame", "MainMenuBarHolderFrame", UIParent, "SecureHandlerStateTemplate")
		holder:SetSize(LolzenUIcfg["actionbar_button_size"]*12+LolzenUIcfg["actionbar_button_spacing"]*11, LolzenUIcfg["actionbar_button_size"])
		holder:SetPoint(LolzenUIcfg["actionbar_mmb_anchor1"], LolzenUIcfg["actionbar_mmb_parent"], LolzenUIcfg["actionbar_mmb_anchor1"], LolzenUIcfg["actionbar_mmb_posx"], LolzenUIcfg["actionbar_mmb_posy"])
		
		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local ab = _G["ActionButton"..i]
			ab:SetSize(LolzenUIcfg["actionbar_button_size"], LolzenUIcfg["actionbar_button_size"])
			if i == 1 then
				ab:ClearAllPoints()
				ab:SetPoint("BOTTOMLEFT", holder, 0, 0)
			else
				ab:ClearAllPoints()
				ab:SetPoint("LEFT", _G["ActionButton"..i-1], "RIGHT", LolzenUIcfg["actionbar_button_spacing"], 0)
			end
		end
		modded = true
	end
end)