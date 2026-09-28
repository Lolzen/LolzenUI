--// inspect // --
-- Enhanced mouseover inspect with caching

local _, ns = ...
local L = ns.L

ns.RegisterModule("inspect", L["desc_inspect"], false)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "Blizzard_InspectUI" then
		if LolzenUIcfg.modules["inspect"] == false then return end

		--end
	end
end)