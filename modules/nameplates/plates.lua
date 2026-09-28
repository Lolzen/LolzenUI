--// nameplates // --

local _, ns = ...
local L = ns.L
local LSM = LibStub("LibSharedMedia-3.0")
local oUF = ns.oUF

ns.RegisterModule("nameplates", L["desc_nameplates"], true)

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["nameplates"] == false then return end

		
	end
end)