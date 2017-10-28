--// options for worldmap //--

local addon, ns = ...

ns.RegisterModule("worldmap")

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" and LolzenUIcfg.modules["worldmap"] == true then

		local title = ns.createTitle("worldmap")

		local about = ns.createDescription("worldmap", "Scales the Worldmap")
		about:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)

		local scale_text = ns.createFonstring("worldmap", "Worldmap Scale:")
		scale_text:SetPoint("TOPLEFT", about, "BOTTOMLEFT", 0, -20)
		
		local desc = ns.createFonstring("worldmap", "Only use numbers or numbers with decimals (0.75), otherwise it will default to 1")
		desc:SetPoint("TOPLEFT", scale_text, "BOTTOMLEFT", 0, -8)

		local scale = ns.createInputbox("worldmap", 30, 20, LolzenUIcfg.worldmap["worldmap_scale"])
		scale:SetPoint("LEFT", scale_text, "RIGHT", 10, 0)

		ns["worldmap"].okay = function(self)
			LolzenUIcfg.worldmap["worldmap_scale"] = tonumber(eb:GetText())
		end

		ns["worldmap"].default = function(self)
			LolzenUIcfg.worldmap["worldmap_scale"] = 1
			ReloadUI()
		end
	end
end)