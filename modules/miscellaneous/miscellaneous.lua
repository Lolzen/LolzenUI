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
		if LolzenUIcfg.miscellaneous["misc_alternative_faction_colors"] == true then
			local factionOffset = FauxScrollFrame_GetOffset(ReputationListScrollFrame)
			for i=1, NUM_FACTIONS_DISPLAYED, 1 do
				local factionIndex = factionOffset + i
				local factionBar = _G["ReputationBar"..i.."ReputationBar"]
				local name, description, standingID, barMin, barMax, barValue, atWarWith, canToggleAtWar, isHeader, isCollapsed, hasRep, isWatched, isChild, factionID, hasBonusRepGain, canBeLFGBonus = GetFactionInfo(factionIndex) 
				local color = LolzenUIcfg.miscellaneous["misc_faction_colors"][standingID]
				factionBar:SetStatusBarColor(unpack(color))
			end
		end
	end
	hooksecurefunc("ReputationFrame_Update", customizeReputationColors)

	-- MicroButtons
	local MicroButtons = {
		CharacterMicroButton, SpellbookMicroButton, TalentMicroButton, 
		AchievementMicroButton, QuestLogMicroButton, GuildMicroButton, 
		PVPMicroButton, LFDMicroButton, CompanionsMicroButton,
		EJMicroButton, HelpMicroButton, MainMenuMicroButton,
		CollectionsMicroButton,
	}

	local oAchievementMicroButton_Update = AchievementMicroButton_Update
	local function setMBV()
		if LolzenUIcfg.miscellaneous["misc_hide_microbuttons"] == true then
			--fix a blizz bug; thx tuller
			if not _G['AchievementMicroButton_Update'] then
				_G['AchievementMicroButton_Update'] = function() end
			end

			-- special snowflake microbutton
		--	StoreMicroButton:Hide()
		--	StoreMicroButton.Show = function() end
			StoreMicroButton:SetAlpha(0)
			StoreMicroButton:EnableMouse(false)

			for _, frame in pairs(MicroButtons) do
				frame:Hide()
			end
		else
			_G['AchievementMicroButton_Update'] = oAchievementMicroButton_Update

			StoreMicroButton:SetAlpha(1)
			StoreMicroButton:EnableMouse(true)

			for _, frame in pairs(MicroButtons) do
				frame:Show()
			end
		end
	end
	setMBV()

	ns.updateCustomRepColors = function()
		ReputationFrame_Update()
	end

	ns.updateMicroButtonVisibility = function()
		setMBV()
	end
end)