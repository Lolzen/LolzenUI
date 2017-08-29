--// options for inspect //--

local addon, ns = ...

ns.RegisterModule("inspect")

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
		
		local bignotice = ns["inspect"]:CreateFontString(nil, "ARTWORK")
		bignotice:SetPoint("CENTER", ns["inspect"], "CENTER", 0, -8)
		bignotice:SetFont("Interface\\AddOns\\LolzenUI\\fonts\\DroidSansBold.ttf", 28, "OUTLINE")
		bignotice:SetText("No options, because this is a utility module")
		bignotice:SetTextColor(1, 1, 1, 0.2)
	end
end)