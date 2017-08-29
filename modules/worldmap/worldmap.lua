--// worldmap // --

local f = CreateFrame("Frame")
f:RegisterEvent("ADDON_LOADED")
f:SetScript("OnEvent", function(self, event, addon)
	if addon == "LolzenUI" then
		if LolzenUIcfg.modules["worldmap"] == false then return end

		UIPanelWindows["WorldMapFrame"] = {area = "center", pushable = 9}
		hooksecurefunc(WorldMapFrame, "Show", function(self)
			self:SetScale(LolzenUIcfg.worldmap["worldmap_scale"])
		end)
	end
end)
