--// MultiBarBottomRight //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local mbbr = _G["MultiBarBottomRightButton"..i]
			mbbr:SetSize(LolzenUIcfg["actionbar_button_size"], LolzenUIcfg["actionbar_button_size"])
			if i == 1 then
				mbbr:ClearAllPoints()
				mbbr:SetPoint(LolzenUIcfg["actionbar_mbbr_anchor1"], LolzenUIcfg["actionbar_mbbr_parent"], LolzenUIcfg["actionbar_mbbr_anchor2"], LolzenUIcfg["actionbar_mbbr_posx"], LolzenUIcfg["actionbar_mbbr_posy"])
			else
				mbbr:ClearAllPoints()
				mbbr:SetPoint("LEFT", _G["MultiBarBottomRightButton"..i-1], "RIGHT", LolzenUIcfg["actionbar_button_spacing"], 0)
			end
		end
		modded = true
	end
end)