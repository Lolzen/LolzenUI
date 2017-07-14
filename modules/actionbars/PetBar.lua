--// PetBar //--

local addon, ns = ...

local modded
local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg["actionbars"] == false then return end
		if modded == true then return end

		PetActionButton1:ClearAllPoints()
		PetActionButton1:SetPoint(LolzenUIcfg["actionbar_petb_anchor1"], LolzenUIcfg["actionbar_petb_parent"], LolzenUIcfg["actionbar_petb_anchor2"], LolzenUIcfg["actionbar_petb_posx"], LolzenUIcfg["actionbar_petb_posy"])
		PetActionBarFrame:SetFrameStrata('HIGH')

		for i = 1, NUM_ACTIONBAR_BUTTONS do
			local pab = _G["PetActionButton"..i]
			if pab then
				pab:SetSize(LolzenUIcfg["actionbar_button_size"], LolzenUIcfg["actionbar_button_size"])
			end
		end
		modded = true
	end
end)