--// miscellaneous // --

local _, ns = ...
local L = ns.L

ns.RegisterModule("miscellaneous", L["desc_miscellaneous"], true)

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

	-- MicroButtons
	local MicroButtons = {
	--	CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
	--	AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, 
	--	PVPMicroButton, LFDMicroButton, CompanionsMicroButton,
	--	EJMicroButton, HelpMicroButton, MainMenuMicroButton,
	--	CollectionsMicroButton,
		CharacterMicroButton, SpellbookMicroButton, QuestLogMicroButton, SocialsMicroButton, WorldMapMicroButton,
		MainMenuMicroButton, HelpMicroButton,
	}

	if LolzenUIcfg.miscellaneous["misc_hide_microbuttons"] == true then
		--fix a blizz bug; thx tuller
	--	if not _G['AchievementMicroButton_Update'] then
	--		_G['AchievementMicroButton_Update'] = function() end
	--	end

		-- special snowflake microbutton
	--	StoreMicroButton:SetAlpha(0)
	--	StoreMicroButton:EnableMouse(false)
		
		for _, frame in pairs(MicroButtons) do
			frame:SetParent(invisible)
			frame:Hide()
		end
	end
end)