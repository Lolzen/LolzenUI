﻿--// MultiBarBottomLeft //--

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["actionbars"] == false then return end
		if modded == true then return end

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbbl = _G["MultiBarBottomLeftButton"..i]
			mbbl:SetSize(LolzenUIcfg.actionbar["actionbar_button_size"], LolzenUIcfg.actionbar["actionbar_button_size"])
			if i == 1 then
				mbbl:ClearAllPoints()
				mbbl:SetPoint(LolzenUIcfg.actionbar["actionbar_mbbl_anchor1"], LolzenUIcfg.actionbar["actionbar_mbbl_parent"], LolzenUIcfg.actionbar["actionbar_mbbl_anchor2"], LolzenUIcfg.actionbar["actionbar_mbbl_posx"], LolzenUIcfg.actionbar["actionbar_mbbl_posy"])
			else
				mbbl:ClearAllPoints()
				mbbl:SetPoint("LEFT", _G["MultiBarBottomLeftButton"..i-1], "RIGHT", LolzenUIcfg.actionbar["actionbar_button_spacing"], 0)
			end
		end
		modded = true
	end
end)