--// MultiBarBottomRight //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		MultiBarBottomRightButton1:ClearAllPoints()  
		MultiBarBottomRightButton1:SetPoint("BOTTOMLEFT", MultiBarBottomLeftButton1, "TOPLEFT", 0, 6)

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbbr = _G["MultiBarBottomRightButton"..i]
			mbbr:SetSize(LolzenUIcfg["actiobar_button_size"], LolzenUIcfg["actiobar_button_size"])
		end
		modded = true
	end
end)