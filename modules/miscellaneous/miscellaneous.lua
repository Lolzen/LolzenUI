--// miscellaneous // --

local _, ns = ...

ns.RegisterModule("miscellaneous", "Miscellaneous options", true)

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:SetScript("OnEvent", function(self, event, addon)
	if LolzenUIcfg.modules["miscellaneous"] == false then return end

	-- ReputationFrame
	local function customizeReputationColors()
		local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
		for i=1, NUM_FACTIONS_DISPLAYED, 1 do
			local factionIndex = factionOffset + i
			local factionBar = _G["ReputationBar"..i.."ReputationBar"]
			local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex)
			local color = LolzenUIcfg.miscellaneous["misc_faction_colors"][standingID]
			factionBar:SetStatusBarColor(unpack(color))
		end
	end
	if LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
		hooksecurefunc("ReputationFrame_Update", customizeReputationColors)
	end
end)