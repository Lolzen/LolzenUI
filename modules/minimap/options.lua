--// options for minimap //--

local addon, ns = ...

ns.RegisterModule("minimap")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["minimap"] == true then

		local title = ns.createTitle("minimap")

		local about = ns.createDescription("minimap", "A clean Minimap")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local cb1 = ns.createCheckBox("minimap", "squareMinimap", "|cff5599ffsquare Minimap|r", LolzenUIcfg.minimap["minimap_square"])
		cb1:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)

		ns["minimap"].okay = function(self)
			if cb1:GetChecked(true) then
				LolzenUIcfg.minimap["minimap_square"] = true
			else
				LolzenUIcfg.minimap["minimap_square"] = false
			end
		end

		ns["minimap"].default = function(self)
			LolzenUIcfg.minimap["minimap_square"] = true
			ReloadUI()
		end
	end
end)