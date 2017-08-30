--// options for nameplates //--

local addon, ns = ...

ns.RegisterModule("nameplates")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["nameplates"] == true then

		local title = ns["nameplates"]:Createnameplatestring(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["nameplates"], 16, -16)
		title:SetText("|cff5599ff"..ns["nameplates"].name.."|r")

		local about = ns["nameplates"]:Createnameplatestring(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("[WiP] Modifies the Nameplates. Requires oUF.")

		ns["nameplates"].okay = function(self)
		end

		ns["nameplates"].default = function(self)
		--	ReloadUI()
		end
	end
end)