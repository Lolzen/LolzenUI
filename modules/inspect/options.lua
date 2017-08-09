--// options for inspect //--

local addon, ns = ...

if not ns.modules["inspect"] then
	tinsert(ns.modules, "inspect")
end

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["inspect"] == true then
		local title = ns["inspect"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["inspect"], 16, -16)
		title:SetText("|cff5599ff"..ns["inspect"].name.."|r")

		local about = ns["inspect"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Fixes unit inspection on Mouseover targets (with keybind)")
	end
end)