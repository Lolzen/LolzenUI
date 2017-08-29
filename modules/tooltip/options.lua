--// options for tooltip //--

local addon, ns = ...

ns.RegisterModule("tooltip")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["tooltip"] == true then

		local title = ns["tooltip"]:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
		title:SetPoint("TOPLEFT", ns["tooltip"], 16, -16)
		title:SetText("|cff5599ff"..ns["tooltip"].name.."|r")

		local about = ns["tooltip"]:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
		about:SetText("Modifies the look of the Tooltip. Also adds a few features like factionicons, spec display, targetdisplay,...")

		local notice = ns["tooltip"]:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		notice:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		notice:SetText("|cff5599ffTO BE DONE, REWORK|r")

		ns["tooltip"].okay = function(self)
		
		end

		ns["tooltip"].default = function(self)
			ReloadUI()
		end
	end
end)